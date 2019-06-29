require 'rails_helper'

RSpec.describe LatestRepeatExpenseDecorator do
  let(:latest_repeat_expense) { LatestRepeatExpense.new.extend LatestRepeatExpenseDecorator }
  subject { latest_repeat_expense }
  it { should be_a LatestRepeatExpense }
end
