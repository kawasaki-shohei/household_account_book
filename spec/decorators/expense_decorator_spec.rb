require 'rails_helper'

RSpec.describe ExpenseDecorator do
  let(:expense) { Expense.new.extend ExpenseDecorator }
  subject { expense }
  it { should be_a Expense }
end
