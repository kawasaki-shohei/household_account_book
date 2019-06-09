require 'rails_helper'

RSpec.describe NotificationDecorator do
  let(:notification) { Notification.new.extend NotificationDecorator }
  subject { notification }
  it { should be_a Notification }
end
