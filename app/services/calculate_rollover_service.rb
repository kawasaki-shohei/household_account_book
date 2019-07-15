class CalculateRolloverService

  # @param [User] user
  # @param [User] partner
  # @param [Pay::ActiveRecord_AssociationRelation] pays
  # @param [Expense::ActiveRecord_AssociationRelation] expenses
  # @param [Integer] n_month_ago
  # @return [CalculateRolloverService]
  def initialize(user, partner, pays, expenses, n_month_ago: 1)
    @user = user
    @partner = partner
    expenses_until_one_month = expenses.find_all { |expense| expense.date <= Date.current.months_ago(n_month_ago).end_of_month }
    @user_expenses = expenses_until_one_month.find_all { |expense| expense.user == @user}
    @partner_expenses = expenses_until_one_month.find_all { |expense| expense.user == @partner}
    @pays = pays.find_all { |pay| pay.date <= Date.current.months_ago(n_month_ago == 1 ? 0 : n_month_ago).end_of_month }
  end

  def call
    calculate_rollover
  end

  private

  attr_reader :user, :partner, :user_expenses, :partner_expenses, :pays

  # @return [Integer]
  def calculate_rollover
    (own_necessary_payment_until_last_month + partner_all_payment) - (own_total_paid_amount_for_both_expenses + own_all_payment)
  end

  # 過去から指定月までの自分が支払わなければいけない金額
  # @return [Integer]
  def own_necessary_payment_until_last_month
    user_expenses.sum(&:mypay) + partner_expenses.sum(&:partnerpay)
  end

  # 過去全てのパートナーの手渡し金額の総額
  # @return [Integer]
  def partner_all_payment
    pays.find_all { |pay| pay.user == partner }.sum(&:amount)
  end

  # 過去から指定月までの自分の全ての二人の出費のために支払っている金額
  # @return [Integer]
  def own_total_paid_amount_for_both_expenses
    user_expenses.sum(&:amount)
  end

  # @return [Integer]
  def own_all_payment
    pays.find_all { |pay| pay.user == user }.sum(&:amount)
  end
end