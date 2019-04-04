require 'rails_helper'

RSpec.describe CategoryDecorator do
  let(:category) { Category.new.extend CategoryDecorator }
  subject { category }
  it { should be_a Category }
end
