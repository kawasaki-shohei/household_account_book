require 'rails_helper'

RSpec.describe CalculateRolloverService, type: :service do
  before do
    @user = create(
      :user_with_partner,
      :with_this_and_last_expenses,
      :with_expenses_before_last_month,
      :with_partner_this_and_last_expenses,
      :with_partner_expenses_before_last_month
    )
    @partner = @user.partner
    create_list(:pay, 5, amount: 10000, user: @user)
    create_list(:pay, 5, amount: 20000, user: @partner)
    @all_pays = Pay.get_couple_pays(@user, @partner)
    period = Date.current.to_s_as_period
    @expenses = Expense.both_expenses_until_one_month(@user, @partner, period)
  end

  it "returns correct rollover amount for own" do
    @service_for_own = CalculateRolloverService.new(@user, @partner, @all_pays, @expenses)
    result = @service_for_own.call
    expect(result).to eq(180000)
  end

  it "returns correct rollover amount for partner" do
    @service_for_partner = CalculateRolloverService.new(@partner, @user, @all_pays, @expenses)
    result = @service_for_partner.call
    expect(result).to eq(-180000)
  end

end