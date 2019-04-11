require 'rails_helper'

RSpec.describe CommonDecorator do
  let(:common) { Common.new.extend CommonDecorator }
  subject { common }
  it { should be_a Common }
end
