# ## Schema Information
#
# Table name: `expenses`
#
# ### Columns
#
# Name                     | Type               | Attributes
# ------------------------ | ------------------ | ---------------------------
# **`id`**                 | `bigint(8)`        | `not null, primary key`
# **`amount`**             | `integer`          |
# **`date`**               | `date`             |
# **`is_for_both`**        | `boolean`          | `default(FALSE)`
# **`memo`**               | `string`           |
# **`mypay`**              | `integer`          |
# **`partnerpay`**         | `integer`          |
# **`percent`**            | `integer`          | `default("pay_all"), not null`
# **`created_at`**         | `datetime`         | `not null`
# **`updated_at`**         | `datetime`         | `not null`
# **`category_id`**        | `integer`          |
# **`repeat_expense_id`**  | `bigint(8)`        |
# **`user_id`**            | `integer`          |
#
# ### Indexes
#
# * `index_expenses_on_repeat_expense_id`:
#     * **`repeat_expense_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`repeat_expense_id => repeat_expenses.id`**
#

require 'rails_helper'

RSpec.describe Expense, type: :model do
  describe "Validation Check" do
    before do
      @user = create(:user)
      @own_category = create(:own_category){ |c| c.user = @user }
      @both_category = create(:both_category){ |c| c.user = @user }
    end

    context "when own expenses" do
      it "is valid with a amount, user_id, category_id and date" do
        expense = Expense.new(
          user: @user,
          category: @own_category,
          amount: 1000,
          date: Time.zone.today
        )
        expect(expense).to be_valid
      end

      it "is invalid without a amount" do
        expense = Expense.new(
          user: @user,
          category: @own_category,
          amount: nil,
          date: Time.zone.today
        )
        expect(expense).to be_invalid
      end

      it "is invalid without a date" do
        expense = Expense.new(
          user: @user,
          category: @own_category,
          amount: 1000,
          date: nil
        )
        expect(expense).to be_invalid
      end

      it "is invalid without a category_id" do
        expense = Expense.new(
          user: @user,
          category: nil,
          amount: 1000,
          date: Time.zone.today
        )
        expect(expense).to be_invalid
      end

      it "is invalid without a user_id" do
        expense = Expense.new(
          user: nil,
          category: @own_category,
          amount: 1000,
          date: Time.zone.today
        )
        expect(expense).to be_invalid
      end

      # todo: 境界値をテスト
    end

    context "when both expenses" do
      it "is valid with a amount, user_id, category_id, date, for_both_expense, percent, mypay and partnerpay" do
        expense = Expense.new(
          user: @user,
          category: @both_category,
          amount: 1000,
          date: Time.zone.today,
          is_for_both: true,
          percent: 1,
          mypay: 500,
          partnerpay: 500
        )
        expect(expense).to be_valid
      end

      it "is invalid without mypay" do
        expense = Expense.new(
          user: @user,
          category: @both_category,
          amount: 1000,
          date: Time.zone.today,
          is_for_both: true,
          percent: -1,
          mypay: nil,
          partnerpay: 500
        )
        expect(expense).to be_invalid
        expect(expense.errors.full_messages.size).to eq(1)
        expect(expense.errors.full_messages.first).to eq("入力した金額の合計が支払い金額と一致しません")
      end

      it "is invalid without partnerpay" do
        expense = Expense.new(
          user: @user,
          category: @both_category,
          amount: 1000,
          date: Time.zone.today,
          is_for_both: true,
          percent: -1,
          mypay: 500,
          partnerpay: nil
        )
        expect(expense).to be_invalid
        expect(expense.errors.full_messages.size).to eq(1)
        expect(expense.errors.full_messages.first).to eq("入力した金額の合計が支払い金額と一致しません")
      end

      it "is invalid when additions of mypay and partnerpay is wrong with amount" do
        expense = Expense.new(
          user: @user,
          category: @both_category,
          amount: 1000,
          date: Time.zone.today,
          is_for_both: true,
          percent: -1,
          mypay: 400,
          partnerpay: 500
        )
        expect(expense).to be_invalid
        expect(expense.errors.full_messages.size).to eq(1)
        expect(expense.errors.full_messages.first).to eq("入力した金額の合計が支払い金額と一致しません")
      end

      it "is invalid when being bound with not common category" do
        expense = Expense.new(
          user: @user,
          category: @own_category,
          amount: 1000,
          date: Time.zone.today,
          is_for_both: true,
          percent: 1
        )
        expect(expense).to be_invalid
        expect(expense.errors.full_messages.size).to eq(1)
        expect(expense.errors.full_messages.first).to eq("二人の出費には共通のカテゴリーを選択してください。")
      end

    end
  end

  describe "Check percent, mypay and partnerpay are set correctly" do
    before do
      @user = create(:user_with_partner)
      @category = create(:both_category){ |c| c.user = @user }
    end

    context "when inserting own expense" do
      it "percent is always pay_all" do
        expense = Expense.create(
          user: @user,
          category: @category,
          amount: 1000,
          date: Faker::Date.backward(365)
        )
        expect(expense.is_for_both).to be_falsey
        expect(expense.percent).to eq("pay_all")
      end
    end

    context "when inserting both expense with specified percent except from manual_amount" do
      it "mypay and partnerpay are set automatically with correct value when percent is pay_all" do
        expense = Expense.create(
          user: @user,
          category: @category,
          amount: 1000,
          date: Time.zone.today,
          is_for_both: true,
          percent: 0
        )
        expect(expense.percent).to eq("pay_all")
        expect(expense.mypay).to be == 1000
        expect(expense.partnerpay).to be == 0
      end

      it "mypay and partnerpay are set automatically with correct value when percent is pay_half" do
        expense = Expense.create(
          user: @user,
          category: @category,
          amount: 1000,
          date: Time.zone.today,
          is_for_both: true,
          percent: 1
        )
        expect(expense.percent).to eq("pay_half")
        expect(expense.mypay).to be == 500
        expect(expense.partnerpay).to be == 500
      end

      it "mypay and partnerpay are set automatically with correct value when percent is pay_one_third" do
        expense = Expense.create(
          user: @user,
          category: @category,
          amount: 1000,
          date: Time.zone.today,
          is_for_both: true,
          percent: 2
        )
        expect(expense.percent).to eq("pay_one_third")
        expect(expense.mypay).to be == 333
        expect(expense.partnerpay).to be == 667
      end

      it "mypay and partnerpay are set automatically with correct value when percent is pay_two_thirds" do
        expense = Expense.create(
          user: @user,
          category: @category,
          amount: 1000,
          date: Time.zone.today,
          is_for_both: true,
          percent: 3
        )
        expect(expense.percent).to eq("pay_two_thirds")
        expect(expense.mypay).to be == 666
        expect(expense.partnerpay).to be == 334
      end

      it "mypay and partnerpay are set automatically with correct value when percent is pay_nothing" do
        expense = Expense.create(
          user: @user,
          category: @category,
          amount: 1000,
          date: Time.zone.today,
          is_for_both: true,
          percent: 4
        )
        expect(expense.percent).to eq("pay_nothing")
        expect(expense.mypay).to be == 0
        expect(expense.partnerpay).to be == 1000
      end
    end
  end

  describe "for Pay page" do
    before do
      @user = create(:user_with_partner)
      @partner = @user.partner
      create_list(:own_category, 5, user: @user)
      create_list(:both_category, 5, user: @user)
      @own_categories = Category.ones_categories(@user)
      @both_categories = @own_categories.find_all{ |c| c.is_common? }

      this_year = Date.current.year
      this_month = Date.current.month
      last_month_year = Date.current.last_month.year
      last_month = Date.current.last_month.month

      # 自分の出費
      10.times do
        # 今月の自分の出費10,000分
        this_month_expense = @user.build_expenses_instances(this_year, this_month, @own_categories.sample, is_for_both: false)
        this_month_expense.amount = 1000
        this_month_expense.save!

        # 先月の自分の出費10,000円分
        last_month_expense = @user.build_expenses_instances(last_month_year, last_month, @own_categories.sample, is_for_both: false)
        last_month_expense.amount = 1000
        last_month_expense.save!
      end

      # 二人の出費
      def create_own_both_expenses(year, month)
        one_month_both_expense = @user.build_expenses_instances(year, month, @both_categories.sample, is_for_both: true)
        5.times do
          manual_amount_expense = one_month_both_expense.dup
          manual_amount_expense.assign_attributes(
            amount: 5000,
            percent: "manual_amount",
            mypay: 1000,
            partnerpay: 4000
          )
          manual_amount_expense.save!

          pay_all_expense = one_month_both_expense.dup
          pay_all_expense.assign_attributes(
            amount: 1000,
            percent: "pay_all"
          )
          pay_all_expense.save!

          pay_half_expense = one_month_both_expense.dup
          pay_half_expense.assign_attributes(
            amount: 8000,
            percent: "pay_half"
          )
          pay_half_expense.save!

          pay_one_third_expense = one_month_both_expense.dup
          pay_one_third_expense.assign_attributes(
            amount: 3000,
            percent: "pay_one_third"
          )
          pay_one_third_expense.save!

          pay_two_thirds_expense = one_month_both_expense.dup
          pay_two_thirds_expense.assign_attributes(
            amount: 3000,
            percent: "pay_two_thirds"
          )
          pay_two_thirds_expense.save!

          pay_nothing_expense = one_month_both_expense.dup
          pay_nothing_expense.assign_attributes(
            amount: 2000,
            percent: "pay_nothing"
          )
          pay_nothing_expense.save!
        end
      end

      def create_partner_both_expenses(year, month)
        one_month_both_expense = @partner.build_expenses_instances(year, month, @both_categories.sample, is_for_both: true)
        5.times do
          manual_amount_expense = one_month_both_expense.dup
          manual_amount_expense.assign_attributes(
            amount: 10000,
            percent: "manual_amount",
            mypay: 2000,
            partnerpay: 8000
          )
          manual_amount_expense.save!

          pay_all_expense = one_month_both_expense.dup
          pay_all_expense.assign_attributes(
            amount: 2000,
            percent: "pay_all"
          )
          pay_all_expense.save!

          pay_half_expense = one_month_both_expense.dup
          pay_half_expense.assign_attributes(
            amount: 16000,
            percent: "pay_half"
          )
          pay_half_expense.save!

          pay_one_third_expense = one_month_both_expense.dup
          pay_one_third_expense.assign_attributes(
            amount: 6000,
            percent: "pay_one_third"
          )
          pay_one_third_expense.save!

          pay_two_thirds_expense = one_month_both_expense.dup
          pay_two_thirds_expense.assign_attributes(
            amount: 6000,
            percent: "pay_two_thirds"
          )
          pay_two_thirds_expense.save!

          pay_nothing_expense = one_month_both_expense.dup
          pay_nothing_expense.assign_attributes(
            amount: 4000,
            percent: "pay_nothing"
          )
          pay_nothing_expense.save!
        end
      end

      # 今月分
      create_own_both_expenses(this_year, this_month)
      create_partner_both_expenses(this_year, this_month)
      # 先月分
      create_own_both_expenses(last_month_year, last_month)
      create_partner_both_expenses(last_month_year, last_month)

    end

    context "when" do
      it "both_this_month" do
        period = Date.current.to_s_as_period
        my_payment = Expense.both_one_month(@user, period)
        expect(my_payment).to eq(65000)
      end

      it "both_last_month" do
        period = Date.current.last_month.to_s_as_period
        my_payment = Expense.both_one_month(@user, period)
        expect(my_payment).to eq(65000)
      end
    end
  end

end
