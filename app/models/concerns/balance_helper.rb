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
    Balance.make_balances_from(balance_lists)
  end
  alias_method :go_calculate_balance, :control_calculate_balance

  # commit後にわかるように、before_saveで変更点を格納しておく。
  def set_differences
    self.differences = changes
  end

  # balance_calculatorのインスタンスが生成された時点のattributesのログを出す
  def output_bc_log(object, balance_calculator)
    message = "starting calculate balance after commit #{self.class.name} instance, id: #{object.id}, period: #{object.date.to_s_as_period}"
    LoggerUtility.output_info_log({class_name: self.class.name, method: __method__, user: object.user, message: message})
    LoggerUtility.output_bc_log(balance_calculator)
  end
  private :output_bc_log

  # ExpenseとIncomeのcommit後に、そのインスタンスを元にして、balanceを計算するクラス
  class BalanceCalculator
    attr_accessor :object, :user, :partner, :is_for_new, :is_for_destroyed_object, :period, :period_was, :object_differences, :period_is_future, :period_was_is_future, :is_for_both_expense, :is_changed_over_period, :is_for_both_expense_and_over_period, :skip_calculate_balance

    # @param Expense or Income
    def initialize(_object)
      @object = _object
      @user = object.user
      @partner = object.user.partner
      @period = object.date.to_s_as_period
      @is_for_new = object.is_new
      @is_for_destroyed_object = object.is_destroyed
      @object_differences = object.differences
      if object.is_a?(Expense) && object.is_for_both?
        @is_for_both_expense = true
      end
      if !is_for_new && !is_for_destroyed_object && object_differences[:date]
        @period_was = object_differences[:date][0].to_s_as_period
      end
      @period_is_future = @period && period.is_after_next_month?
      @period_was_is_future = @period_was && period_was.is_after_next_month?
      set_is_changed_over_period
      @is_for_both_expense_and_over_period = is_for_both_expense && is_changed_over_period
      set_skip_calculate_balance
    end

    # dateが月をまたいで変更されていればis_changed_over_periodにtrueをセットして返す。
    # ex) "2018-12-20" → "2019-01-05" tureを返す
    def set_is_changed_over_period
      return false if is_for_new || is_for_destroyed_object || !object_differences[:date]
      self.is_changed_over_period = period_was != period
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
      if period_is_future && is_for_new
        self.skip_calculate_balance = true and return
      end

      # 来月以降のレコードでないものが削除されたらbalanceを計算する
      if !period_is_future && is_for_destroyed_object
        self.skip_calculate_balance = false and return
      elsif period_is_future && is_for_destroyed_object
        self.skip_calculate_balance = true and return
      end

      # 来月以降のレコードの日付の変更があったときは、balanceは計算しない。
      if !is_for_destroyed_object && object_differences[:date] && period_is_future && period_was_is_future
        self.skip_calculate_balance = true and return
      end


      # 来月以降のものではなく、新規登録でもなく、削除したわけでもなく、balanceが変わるような日付の変更をしていないのであれば、金額に関係するattributesを調べればいい。
      if is_for_new || is_changed_over_period || is_for_destroyed_object || (money_attributes_are_changed? && !period_is_future)
        self.skip_calculate_balance = false
      else
        self.skip_calculate_balance = true
      end
    end

    # balanceを作成するための1リストを作成
    def make_list_hash(user, period)
      {
        amount: self.class.calculate_balance_amount(user, period),
        period: period,
        user: user
      }
    end

    # balanceを生成するための注文書を作成
    def make_balance_lists
      lists = []
      unless skip_calculate_balance || period_is_future
        lists << make_list_hash(user, period)
      end
      if is_for_both_expense && !period_is_future
        lists << make_list_hash(partner, period)
      end
      if is_changed_over_period && !period_was_is_future
        lists << make_list_hash(user, period_was)
      end
      if is_for_both_expense_and_over_period && !period_was_is_future
        lists << make_list_hash(partner, period_was)
      end
      lists
    end

    # 該当月の収支バランス金額を計算する
    # @param String :period
    def self.calculate_balance_amount(user, period)
      Income.one_month_total_income(user, period) - Expense.one_month_total_expenditures(user, period)
    end

    # このクラスのattributesを全て取得
    def self.attributes
      [
        :object, :user, :partner, :is_for_new, :is_for_destroyed_object, :period, :period_was, :object_differences, :period_is_future, :period_was_is_future, :is_for_both_expense, :is_changed_over_period, :is_for_both_expense_and_over_period, :skip_calculate_balance
      ]
    end

  end

end