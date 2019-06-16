require 'rails_helper'

RSpec.describe RepeatExpenseDecorator do
  let(:repeat_expense) { RepeatExpense.new.extend RepeatExpenseDecorator }
  subject { repeat_expense }
  it { should be_a RepeatExpense }
end
