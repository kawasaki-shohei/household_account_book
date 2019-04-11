require 'rails_helper'

RSpec.describe DepositDecorator do
  let(:deposit) { Deposit.new.extend DepositDecorator }
  subject { deposit }
  it { should be_a Deposit }
end
