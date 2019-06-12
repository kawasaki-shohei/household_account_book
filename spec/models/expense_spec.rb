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
      @user = FactoryBot.create(:user)
      @category = FactoryBot.create(:category)
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

end
