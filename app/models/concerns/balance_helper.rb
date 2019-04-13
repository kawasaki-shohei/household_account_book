# ExpenseとIncomeのコールバックでBalanceの計算に使うモジュール
module BalanceHelper

  # balanceの計算をするかどうか制御するメソッド。
  def control_calculate_balance(object)
    balance_calculator = BalanceHelper::BalanceCalculator.new(object)
    output_bc_log(object, balance_calculator)

    if balance_calculator.skip_calculate_balance
      LoggerUtility.inform_unrelated_to_balance(object) and return
    end

    balance_lists = balance_calculator.make_balance_lists
    Balance.create_or_update_balance(balance_lists)
  end
  alias_method :go_calculate_balance, :control_calculate_balance

  # commit後にわかるように、before_saveで変更点を格納しておく。
  def set_differences
    self.differences = changes
  end

  # balance_calculatorのインスタンスが生成された時点のattributesのログを出す
  def output_bc_log(object, balance_calculator)
    message = "starting calculate balance after commit #{self.class.name} instance, id: #{object.id}, month: #{object.date.to_s_as_year_month}"
    LoggerUtility.output_info_log({class_name: self.class.name, method: __method__, user: object.user, message: message})
    LoggerUtility.output_bc_log(balance_calculator)
  end
  private :output_bc_log

  # ExpenseとIncomeのcommit後に、そのインスタンスを元にして、balanceを計算するクラス
  class BalanceCalculator
    attr_accessor :object, :user, :partner, :is_for_new, :is_for_destroyed_object, :month, :month_was, :object_differences, :month_is_future, :month_was_is_future, :is_for_both_expense,:is_changed_over_month, :is_for_both_expense_and_over_month,:skip_calculate_balance

    # @param Expense or Income
    def initialize(_object)
      self.object = _object
      self.user = object.user
      self.partner = object.user.partner
      self.month = object.date.to_s_as_year_month
      self.is_for_new = object.is_new
      self.is_for_destroyed_object = object.is_destroyed
      self.object_differences = object.differences
      if object.is_a?(Expense) && object.both_flg
        self.is_for_both_expense = true
      end
      if !is_for_new && !is_for_destroyed_object && object_differences[:date]
        self.month_was = object_differences[:date][0].to_s_as_year_month
      end
      self.month_is_future = self.month && month.is_after_next_month?
      self.month_was_is_future = self.month_was && month_was.is_after_next_month?
      set_is_changed_over_month
      self.is_for_both_expense_and_over_month = is_for_both_expense && is_changed_over_month
      set_skip_calculate_balance
    end

    # dateが月をまたいで変更されていればis_changed_over_monthにtrueをセットして返す。
    # ex) "2018-12-20" → "2019-01-05" tureを返す
    def set_is_changed_over_month
      return false if is_for_new || is_for_destroyed_object || !object_differences[:date]
      self.is_changed_over_month = month_was != month
    end

    # 金額に関するattributesが変更されていればtrueを返す。
    def money_attributes_are_changed?
      attributes = object.class.money_attributes
      attributes.each do |attr|
        return true if object_differences.include?(attr)
      end
      return false
    end

    # 収支バランスを計算するか判断する。
    def set_skip_calculate_balance
      # 来月以降の新規登録のbalanceは計算しない
      if month_is_future && is_for_new
        self.skip_calculate_balance = true and return
      end

      # 来月以降のレコードでないものが削除されたらbalanceを計算する
      if !month_is_future && is_for_destroyed_object
        self.skip_calculate_balance = false and return
      elsif month_is_future && is_for_destroyed_object
        self.skip_calculate_balance = true and return
      end

      # 来月以降のレコードの日付の変更があったときは、balanceは計算しない。
      if !is_for_destroyed_object && object_differences[:date] && month_is_future && month_was_is_future
        self.skip_calculate_balance = true and return
      end


      # 来月以降のものではなく、新規登録でもなく、削除したわけでもなく、balanceが変わるような日付の変更をしていないのであれば、金額に関係するattributesを調べればいい。
      if is_for_new || is_changed_over_month || is_for_destroyed_object || (money_attributes_are_changed? && !month_is_future)
        self.skip_calculate_balance = false
      else
        self.skip_calculate_balance = true
      end
    end

    # balanceを作成するための1リストを作成
    def make_list_hash(user, month)
      {
        amount: self.class.calculate_balance_amount(user, month),
        month: month,
        user: user
      }
    end

    # balanceを生成するための注文書を作成
    def make_balance_lists
      lists = []
      unless skip_calculate_balance || month_is_future
        lists << make_list_hash(user, month)
      end
      if is_for_both_expense && !month_is_future
        lists << make_list_hash(partner, month)
      end
      if is_changed_over_month && !month_was_is_future
        lists << make_list_hash(user, month_was)
      end
      if is_for_both_expense_and_over_month && !month_was_is_future
        lists << make_list_hash(partner, month_was)
      end
      lists
    end

    # 該当月の収支バランス金額を計算する
    # @param String :month
    def self.calculate_balance_amount(user, month)
      Income.one_month_total_income(user, month) - Expense.one_month_total_expenditures(user, month)
    end

    # このクラスのattributesを全て取得
    def self.attributes
      [
        :object, :user, :partner, :is_for_new, :is_for_destroyed_object, :month, :month_was, :object_differences, :month_is_future, :month_was_is_future, :is_for_both_expense,:is_changed_over_month, :is_for_both_expense_and_over_month,:skip_calculate_balance
      ]
    end

  end

end