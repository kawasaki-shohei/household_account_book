require 'rails_helper'

RSpec.describe Pay, type: :model do
  describe "Validation Check" do
    before do
      @user = create(:user_with_partner)
    end

    it "is valid with amount, past date, user_id" do
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

    it "is invalid with over 11 digits amount" do
      pay = Pay.new(
        amount: 10000000000,
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

    it "is invalid with future date" do
      pay = Pay.new(
        amount: 10000,
        user: @user,
        date: Date.current.tomorrow
      )
      expect(pay).to be_invalid
      expect(pay.errors.full_messages.size).to eq(1)
      expect(pay.errors.full_messages.first).to eq("未来日は入力できません。")
    end

    it "is invalid without user_id" do
      pay = Pay.new(
        amount: 10000,
        date: Faker::Date.backward(365),
      )
      expect(pay).to be_invalid
    end

    it "is invalid with over 101 letters memo" do
      pay = Pay.new(
        amount: 10000,
        date: Faker::Date.backward(365),
        memo: Faker::String.random(101),
        user: @user
      )
      expect(pay).to be_invalid
    end
  end

  describe "for pays list page" do
    before do
      @user = create(:user_with_partner)
      @partner = @user.partner
      create_list(:pay, 5, user: @user)
      create_list(:pay, 5, user: @partner)
    end

    it "can get all pays for own and partner" do
      pays = Pay.get_couple_pays(@user, @partner)
      own_pays = pays.find_all { |pay| pay.user == @user }
      partner_pays = pays.find_all { |pay| pay.user == @partner }
      expect(own_pays.size).to eq(5)
      expect(partner_pays.size).to eq(5)
    end
  end

end
