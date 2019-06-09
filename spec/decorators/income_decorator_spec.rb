require 'rails_helper'

RSpec.describe IncomeDecorator do
  let(:income) { Income.new.extend IncomeDecorator }
  subject { income }
  it { should be_a Income }
end
