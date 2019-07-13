require 'rails_helper'

RSpec.describe Pay, type: :model do
  describe "Validation Check" do
    before do
      @user = create(:user_with_partner)
    end

    it "is valid with amount, date, user_id" do
      pay = Pay.new(
        amount: 10000,
        date: Faker::Date.backward(365),
        user: @user
      )
      expect(pay).to be_valid
    end

    it "is invalid without amount" do
      pay = Pay.new(
        date: Faker::Date.backward(365),
        user: @user
      )
      expect(pay).to be_invalid
    end

    it "is invalid without date" do
      pay = Pay.new(
        amount: 10000,
        user: @user
      )
      expect(pay).to be_invalid
    end

    it "is invalid without user_id" do
      pay = Pay.new(
        amount: 10000,
        date: Faker::Date.backward(365),
      )
      expect(pay).to be_invalid
    end
  end

  describe "for rollover" do
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
    end

    it "ones_all_payment" do
      own_all_payment = Pay.ones_all_payment(@user)
      partner_all_payment = Pay.ones_all_payment(@partner)
      expect(own_all_payment).to eq(50000)
      expect(partner_all_payment).to eq(100000)
    end

    it "ones_gross" do
      own_ones_gross = Pay.ones_gross(@user)
      partner_ones_gross = Pay.ones_gross(@partner)
      expect(own_ones_gross).to eq(270000)
      expect(partner_ones_gross).to eq(540000)
    end

    it "must_pay" do
      own_must_pay = Pay.must_pay(@user, @partner)
      partner_must_pay = Pay.must_pay(@partner, @user)
      expect(own_must_pay).to eq(350000)
      expect(partner_must_pay).to eq(310000)
    end

    it "balance_of_gross" do
      own_rollover = Pay.balance_of_gross(@user, @partner)
      partner_rollover = Pay.balance_of_gross(@partner, @user)
      expect(own_rollover).to eq(180000)
      expect(partner_rollover).to eq(-180000)
    end
  end

end
