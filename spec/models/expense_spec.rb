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
# **`both_flg`**           | `boolean`          | `default(FALSE)`
# **`date`**               | `date`             |
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
      @category = create(:own_category){ |c| c.user = @user }
    end

    context "when own expenses" do
      it "is valid with a amount, user_id, category_id and date" do
        expense = Expense.new(
          user: @user,
          category: @category,
          amount: 1000,
          date: Time.zone.today
        )
        expect(expense).to be_valid
      end

      it "is invalid without a amount" do
        expense = Expense.new(
          user: @user,
          category: @category,
          amount: nil,
          date: Time.zone.today
        )
        expect(expense).to be_invalid
      end

      it "is invalid without a date" do
        expense = Expense.new(
          user: @user,
          category: @category,
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
          category: @category,
          amount: 1000,
          date: Time.zone.today
        )
        expect(expense).to be_invalid
      end

      # todo: 境界値をテスト
    end

    context "when both expenses" do
      it "is valid with a amount, user_id, category_id, date, true both_flg, percent, mypay and partnerpay" do
        expense = Expense.new(
          user: @user,
          category: @category,
          amount: 1000,
          date: Time.zone.today,
          both_flg: true,
          percent: 1,
          mypay: 500,
          partnerpay: 500
        )
        expect(expense).to be_valid
      end

      it "is invalid without mypay" do
        expense = Expense.new(
          user: @user,
          category: @category,
          amount: 1000,
          date: Time.zone.today,
          both_flg: true,
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
          category: @category,
          amount: 1000,
          date: Time.zone.today,
          both_flg: true,
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
          category: @category,
          amount: 1000,
          date: Time.zone.today,
          both_flg: true,
          percent: -1,
          mypay: 400,
          partnerpay: 500
        )
        expect(expense).to be_invalid
        expect(expense.errors.full_messages.size).to eq(1)
        expect(expense.errors.full_messages.first).to eq("入力した金額の合計が支払い金額と一致しません")
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
        expect(expense.both_flg).to be_falsey
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
          both_flg: true,
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
          both_flg: true,
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
          both_flg: true,
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
          both_flg: true,
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
          both_flg: true,
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
      create_list(:own_category, 5, user: @user)
      create_list(:both_category, 5, user: @user)
      @own_categories = Category.ones_categories(@user)
      @both_categories = @own_categories.find_all{ |c| c.common }
    end

    context "when" do
      it "both_this_month" do
        @expenses = create_list()
      end

      it "both_last_month" do

      end
    end
  end

end
