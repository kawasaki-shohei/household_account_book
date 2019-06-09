require 'rails_helper'

RSpec.describe PayDecorator do
  let(:pay) { Pay.new.extend PayDecorator }
  subject { pay }
  it { should be_a Pay }
end
