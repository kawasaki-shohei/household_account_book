require 'rails_helper'

RSpec.describe Pay, type: :model do
  describe "Validation Check" do
    before do
      @user = create(:user)
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

  it "ones_all_payment" do
  end

  it "ones_gross" do

  end

  it "must_pay" do

  end

  it "balance_of_gross" do

  end
end
