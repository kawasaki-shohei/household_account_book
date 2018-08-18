require 'rails_helper'

RSpec.describe Expense, type: :model do
  it "is valid with a amount, user_id, category_id and date" do
    expense = Expense.new(
      user_id: 1,
      category_id: 1,
      amount: 1000,
      date: Time.zone.today
    )
    expect(expense).to be_valid
  end
  it "is invalid with without a amount"
  it "is invalid with without a date"
  it "is invalid with without a category_id"
  it "is invalid with without a user_id"
end
