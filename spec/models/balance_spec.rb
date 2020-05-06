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
    let!(:user) { create(:user_with_partner) }
    let!(:partner) { user.partner }
    
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
    let!(:user) { create(:user_with_partner) }
    let!(:category) { create(:own_category, user: user)}
    let!(:partner) { user.partner }
    let!(:list) {{ user: user, period: Date.current.to_s_as_period, amount: -1000 }}

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

  describe "Balance after create new expense" do
    context "when there is no this month expense yet" do
      let!(:user) { create(:user_with_partner) }
      let!(:this_month_period) { Date.current.to_s_as_period }
      subject(:exist_this_month_balance?) { user.balances.exists?(period: this_month_period) }

      it "this month balance does not exist" do
        expect(exist_this_month_balance?).to be_falsey
      end

      context "when create this month expense" do
        before do
          create(:own_this_month_expense, amount: 1000, user: user)
          create(:own_category, user: user)
        end
        it "this month balance is created" do
          expect(exist_this_month_balance?).to be_truthy
        end
      end
    end

    context "when there is more than one this month expense and create additional this month expense" do
      let!(:user) { create(:user_with_partner) }
      let!(:category) { create(:own_category, user: user) }
      let!(:own_this_month_expense) { create(:own_this_month_expense, amount: 1000, user: user, category: category) }
      let!(:this_month_period) { own_this_month_expense.date.to_s_as_period }
      let!(:first_own_this_month_balance) { user.balances.find_by(period: this_month_period) }
      let(:target_balances) { user.balances.where(period: this_month_period) }
      let(:target_own_this_month_balance) { user.balances.find_by(period: this_month_period) }
      before { create(:own_this_month_expense, amount: 1000, user: user, category: category) }

      it "only one this month balance exist" do
        expect(target_balances.length).to eq(1)
        expect(target_balances.first.id).to eq(first_own_this_month_balance.id)
      end

      it "this month balance amount is updated" do
        expect(target_own_this_month_balance.amount).to eq(-2000)
      end
    end

    context "when there is more than one past month expense and create additional past month expense" do
      let!(:user) { create(:user_with_partner) }
      let!(:category) { create(:own_category, user: user) }
      let!(:own_past_month_expense) { create(:own_past_month_expense, amount: 1000, user: user, category: category) }
      let!(:past_month_period) { own_past_month_expense.date.to_s_as_period }
      let!(:first_own_past_month_balance) { user.balances.find_by(period: past_month_period) }
      let(:target_balances) { user.balances.where(period: past_month_period) }
      let(:target_own_past_month_balance) { user.balances.find_by(period: past_month_period) }
      before { create(:own_expense, amount: 1000, date: random_specific_month_date(period: past_month_period), user: user, category: category) }

      it "only one past month balance exist" do
        expect(target_balances.length).to eq(1)
        expect(target_balances.first.id).to eq(first_own_past_month_balance.id)
      end

      it "past month balance amount is updated" do
        expect(target_own_past_month_balance.amount).to eq(-2000)
      end
    end

    context "when create new future month expense" do
      let!(:user) { create(:user_with_partner) }
      let!(:category) { create(:own_category, user: user) }
      let!(:own_future_month_expense) { create(:own_future_month_expense, amount: 1000, user: user, category: category) }
      let!(:future_month_period) { own_future_month_expense.date.to_s_as_period }
      subject(:target_own_future_month_balance) { user.balances.find_by(period: future_month_period) }

      it "future month balance will not be created" do
        expect(target_own_future_month_balance).to be_falsey
      end
    end
  end

  describe "Balance after update own expense" do
    let!(:user) { create(:user_with_partner) }
    let!(:category) { create(:own_category, user: user) }

    context "when update own this month expense memo" do
      let!(:own_this_month_expense) { create(:own_this_month_expense, amount: 1000, user: user, category: category) }
      let!(:this_month_period) { own_this_month_expense.date.to_s_as_period }
      let!(:first_own_this_month_balance) { user.balances.find_by(period: this_month_period) }
      let(:target_own_this_month_balance) { user.balances.find_by(period: this_month_period) }
      before { own_this_month_expense.update!(memo: 'update') }

      it "own this month balance amount will not be changed" do
        expect(target_own_this_month_balance.amount).to eq(first_own_this_month_balance.amount)
      end
    end

    context "when update own this month expense category" do
      let!(:own_this_month_expense) { create(:own_this_month_expense, amount: 1000, user: user, category: category) }
      let!(:this_month_period) { own_this_month_expense.date.to_s_as_period }
      let!(:first_own_this_month_balance) { user.balances.find_by(period: this_month_period) }
      let!(:category2) { create(:own_category, user: user) }
      let(:target_own_this_month_balance) { user.balances.find_by(period: this_month_period) }
      before { own_this_month_expense.update!(category: category2) }

      it "own this month balance amount will not be changed" do
        expect(target_own_this_month_balance.amount).to eq(first_own_this_month_balance.amount)
      end
    end

    context "when update own this month expense amount" do
      let!(:own_this_month_expense) { create(:own_this_month_expense, amount: 1000, user: user, category: category) }
      let!(:this_month_period) { own_this_month_expense.date.to_s_as_period }
      let!(:first_own_this_month_balance) { user.balances.find_by(period: this_month_period) }
      let(:target_own_this_month_balance) { user.balances.find_by(period: this_month_period) }
      before { own_this_month_expense.update!(amount: 2000) }

      it "own this month balance amount will not be changed" do
        expect(target_own_this_month_balance.amount).to_not eq(first_own_this_month_balance.amount)
        expect(target_own_this_month_balance.amount).to eq(-2000)
      end
    end

    context "when update own this month expense date into other date in the same month" do
      it "balance will not be changed" do

      end
    end

    context "when update own this month expense date into other date in last month" do
      it "both this and last month balances will be changed" do

      end
    end

    context "when update own this month expense date into other date in future month" do
      it "this month balance will be changed, but future balance will not be created" do

      end
    end

    context "when update own expense of future date into other past date" do
      it "past month balance will be changed" do

      end
    end

    context "when update own this month expense amount and that date into other date in the same month" do
      it "this month balance will be changed" do

      end
    end

    context "when update own this month expense amount and that date into past month date" do
      it "both this month and past month balances will be changed" do

      end
    end

    context "when update own this month expense amount and that date into future month date" do
      it "this month balance will be changed, but future balance will not be created" do

      end
    end
  end

  describe "Balance after delete own expense" do
    context "when delete own this month expense" do
      it "this month balance will be changed" do

      end
    end

    context "when delete own past month expense" do
      it "past month balance will be changed" do

      end
    end

    context "when delete own new month expense" do
      it "balance will not be changed" do

      end
    end
  end

  describe "Balance after change both expense" do
    let!(:user) { create(:user_with_partner) }
    let!(:partner) { user.partner }
    context "create new both expense" do
      it "balance will be changed" do

      end
    end

    context "create new past month both expense" do
      it "past month balance will be changed" do

      end
    end

    context "create new future month both expense" do
      it "balance will change nothing" do

      end
    end

    context "when update both expense memo" do
      it "balance will not be changed" do

      end
    end

    context "when update both expense category" do
      it "balance will not be changed" do

      end
    end

    context "when update both expense amount" do
      it "both own balance and partner balance will be changed" do

      end
    end

    context "when update both expense mypay and partnerpay" do
      it "both own balance and partner balance will be changed" do

      end
    end

    context "when update both expense date into other date in the same month" do
      it "balance will not be changed" do

      end
    end

    context "when update both expense date into other date in past month" do
      it "own this month and the past month balances and partners this month and the past month balances will be changed" do

      end
    end

    context "when update both expense amount and date into the same month date" do
      it "both own balance and partner balance will be changed" do

      end
    end

    context "when update both expense amount and date into past month date" do
      it "own this month and the past month balances and partners this month and the past month balances will be changed" do

      end
    end

    context "when update both expense amount and date into future month date" do
      it "own this month balance and partners this month balance will be changed, but future balance will not be created" do

      end
    end

    context "when update both expense mypay and partnerpay and date into the same month date" do
      it "both own balance and partner balance will be changed" do

      end
    end

    context "when update both expense mypay and partnerpay  and date into past month date" do
      it "own this month and the past month balances and partners this month and the past month balances will be changed" do

      end
    end

    context "when update both expense mypay and partnerpay  and date into future month date" do
      it "own this month balance and partners this month balance will be changed, but future balance will not be created" do

      end
    end

    context "delete both expense" do
      context "delete both expense of not future month" do
        it "own this month balance and partner this month balance will be changed" do

        end
      end

      context "delete future month both expense" do
        it "balance will be changed nothing" do

        end
      end
    end
  end

  describe "Balance after change income" do
    let!(:user) { create(:user_with_partner) }
    let!(:category) { create(:own_category, user: user) }
    let!(:category2) { create(:own_category, user: user) }
    let!(:partner) { user.partner }
    context "when there is no this month income yet" do
      it "this month balance does not exist" do

      end
      context "after create this month income" do
        it "this month balance is created" do

        end
      end
    end

    context "when create income" do
      context "when create income of not future month" do
        it "balance will be changed" do

        end
      end

      context "when create income of future month" do
        it "future balance will not be created" do

        end
      end
    end

    context "when update income" do
      context "when update income amount" do
        it "balance will be changed" do

        end
      end

      context "when update income date into other date in the same month" do
        it "balance will not be changed" do

        end
      end

      context "when update income date into other date in the past month" do
        it "both this month and past month balances will be changed" do

        end
      end

      context "when update income date into other date in the future month" do
        it "this month balance will be changed, but future month balance will not be created" do

        end
      end

      context "when update income amount and date into other date in the past month" do
        it "both this month and past month balances will be changed" do

        end
      end

      context "when update income amount and date into other date in the future month" do
        it "this month balance will be changed, but future balance will not be created" do

        end
      end

      context "when update future month income memo" do
        it "future month balance is not exist" do

        end
      end

      context "when update future month income amount" do
        it "future month balance is not exist" do

        end
      end

      context "when update future month income date into the other date in the same month" do
        it "future month balance is not exist" do

        end
      end

      context "when update future month income date into the other date in not future month" do
        it "this month balance will be changed, but future month is not exist" do

        end
      end

      context "when update future month income amount adn date into the other date in not future month" do
        it "this month balance will be changed, but future month is not exist" do

        end
      end

    end

    context "when delete income" do
      context "delete income of not future month" do
        it "this month balance will be changed" do

        end
      end

      context "delete future month income" do
        it "future month balance is not exist" do

        end
      end
    end

  end
end