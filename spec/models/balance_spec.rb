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

  describe "Balance after change expense or income" do
    let(:user) { create(:user_with_partner) }
    let(:category) { create(:own_category, user: user)}
    let(:partner) { user.partner }

    context "about own expense" do
      let(:own_this_month_expense) { create(:own_this_month_expense, amount: 1000, user: user, category: category) }
      let(:own_last_month_expense) { create(:own_last_month_expense, amount: 1000, user: user, category: category) }
      let(:this_month_period) { own_this_month_expense.date.to_s_as_period }
      let(:last_month_period) { own_last_month_expense.date.to_s_as_period }
      let(:next_month_period) { Date.current.next_month.to_s_as_period }
      let(:own_this_month_balance) { user.balances.find_by(period: this_month_period) }
      let(:own_last_month_balance) { user.balances.find_by(period: last_month_period) }

      context "when create new own expense" do
        context "when create new this month expense" do
          it "balance is updated" do
            create(:own_this_month_expense, amount: 1000, user: user, category: category)
            expect(own_this_month_balance.amount).to eq(-2000)
          end
        end

        context "when create new last month expense" do
          it "balance is updated" do
            create(:own_last_month_expense, amount: 1000, user: user, category: category)
            expect(own_last_month_balance.amount).to eq(-2000)
          end
        end

        context "when create new future month expense" do
          it "balance will not be created" do
            create(:own_next_month_expense, amount: 1000, user: user, category: category)
            balance = user.balances.find_by(period: next_month_period)
            expect(balance).to be_falsey
          end
        end
      end

      context "when update own expense" do
        context "when update own expense memo" do
          it "balance will not be changed" do
            expect {
              own_this_month_expense.update!(memo: 'update')
            }.to_not change(own_this_month_balance, :amount)
          end
        end

        context "when update own expense category" do
          it "balance will not be changed" do

          end
        end

        context "when update own expense amount" do
          it "balance amount will be changed" do

          end
        end

        context "when update own expense date into other date in the same month" do
          it "balance will not be changed" do

          end
        end

        context "when update own expense date into other date in last month" do
          it "both this month and the last month balances will be changed" do

          end
        end

        context "when update own expense date into other date in future month" do
          it "this month balance will be changed, but future balance will not be created" do

          end
        end

        context "when update own expense of future date into other past date" do
          it "last month balance will be changed" do

          end
        end

        context "when update own expense amount and date into this month date" do
          it "this month balance will be changed" do

          end
        end

        context "when update own expense amount and date into last month date" do
          it "both this month and last month balances will be changed" do

          end
        end

        context "when update own expense amount and date into future month date" do
          it "this month balance will be changed, but future balance will not be created" do

          end
        end
      end

      context "when delete own expense" do
        context "delete own expense of not future month" do
          it "this month balance will be changed" do

          end
        end

        context "delete future month own expense" do
          it "balance will be changed nothing" do

          end
        end
      end

    end

    context "when create both expense" do
      context "create new both expense" do
        it "balance will be changed" do

        end
      end

      context "create new last month both expense" do
        it "last month balance will be changed" do

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

      context "when update both expense date into other date in last month" do
        it "own this month and the last month balances and partners this month and the last month balances will be changed" do

        end
      end

      context "when update both expense amount and date into the same month date" do
        it "both own balance and partner balance will be changed" do

        end
      end

      context "when update both expense amount and date into last month date" do
        it "own this month and the last month balances and partners this month and the last month balances will be changed" do

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

      context "when update both expense mypay and partnerpay  and date into last month date" do
        it "own this month and the last month balances and partners this month and the last month balances will be changed" do

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

      context "when update income date into other date in the last month" do
        it "both this month and last month balances will be changed" do

        end
      end

      context "when update income date into other date in the future month" do
        it "this month balance will be changed, but future month balance will not be created" do

        end
      end

      context "when update income amount and date into other date in the last month" do
        it "both this month and last month balances will be changed" do

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
