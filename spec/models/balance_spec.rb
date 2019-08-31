# ## Schema Information
#
# Table name: `balances`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `bigint(8)`        | `not null, primary key`
# **`amount`**      | `integer`          |
# **`period`**      | `string`           |
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
# **`user_id`**     | `bigint(8)`        |
#
# ### Indexes
#
# * `index_balances_on_user_id`:
#     * **`user_id`**
# * `index_balances_on_user_id_and_period` (_unique_):
#     * **`user_id`**
#     * **`period`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`user_id => users.id`**
#

require 'rails_helper'

RSpec.describe Balance, type: :model do
  describe "Validation Check" do
    let(:user) { create(:user_with_partner) }
    let(:partner) { user.partner }
    
    it "is valid with amount, period, user" do
      balance = Balance.new(
        amount: 1000,
        period: "2019-01",
        user: user
      )
      expect(balance).to be_valid
    end

    it "is invalid without amount" do
      balance = Balance.new(
        amount: nil,
        period: "2019-01",
        user: user
      )
      expect(balance).to be_invalid
      expect(balance.errors.details).to eq({:amount=>[{:error=>:blank}]})
    end

    it "is invalid without user" do
      balance = Balance.new(
        amount: 1000,
        period: "2019-01",
        user: nil
      )
      expect(balance).to be_invalid
      expect(balance.errors.details).to eq({:user=>[{:error=>:blank}]})
    end

    it "is invalid without period" do
      balance = Balance.new(
        amount: 1000,
        period: nil,
        user: user
      )
      expect(balance).to be_invalid
      expect(balance.errors.details).to eq({:period=>[{:error=>:blank}, {:error=>:invalid, :value=>nil}]})
    end

    it "is invalid with same user and period" do
      create(:balance, user: user)
      balance = build(:balance, user: user)
      expect(balance).to be_invalid
      expect(balance.errors.details).to eq({:period=>[{:error=>:taken, :value=>balance.period}]})
    end

    it "is invalid with future_month" do
      balance = Balance.new(
        amount: 1000,
        period: Date.current.months_since(1).to_s_as_period,
        user: user
      )
      expect(balance).to be_invalid
      expect(balance.errors[:base]).to eq([I18n.t('balance.validation.future_month_is_invalid')])
    end
  end

  describe ".create_or_update_balance" do
    let(:user) { create(:user_with_partner) }
    let(:category) { create(:own_category, user: user)}
    let(:partner) { user.partner }
    let(:list) {{ user: user, period: Date.current.to_s_as_period, amount: -1000 }}

    context "when specific balance is not exist" do
      it "new balance is created" do
        Balance.create_or_update_balance(list)
        balances = user.balances.where(period: Date.current.to_s_as_period)
        expect(balances.size).to eq(1)
        expect(balances.first.amount).to eq(-1000)
      end
    end

    context "when specific balance is exist" do
      it "balance is updated" do
        expense = create(:own_this_month_expense, user: user, amount: 3000)
        balance = user.balances.find_by(period: Date.current.to_s_as_period)
        expect(balance).to be_truthy
        expect(balance.amount).to eq(-3000)
        Balance.create_or_update_balance(list)
        balance.reload
        expect(balance.amount).to eq(-1000)
      end
    end

    describe ".make_balances_from" do
      it "balances of specific months are exist" do
        balance_lists = [
          { user: user, period: Date.current.to_s_as_period, amount: -1000 },
          { user: user, period: Date.current.last_month.to_s_as_period, amount: -2000 },
        ]
        Balance.make_balances_from(balance_lists)
        this_month_balance = user.balances.find_by(period: Date.current.to_s_as_period)
        last_month_balance = user.balances.find_by(period: Date.current.last_month.to_s_as_period)
        expect(this_month_balance).to be_truthy
        expect(last_month_balance).to be_truthy
      end
    end
  end

end
