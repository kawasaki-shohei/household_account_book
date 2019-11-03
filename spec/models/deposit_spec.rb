# ## Schema Information
#
# Table name: `deposits`
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`id`**            | `bigint(8)`        | `not null, primary key`
# **`amount`**        | `integer`          | `not null`
# **`date`**          | `datetime`         | `not null`
# **`is_withdrawn`**  | `boolean`          | `default(FALSE)`
# **`memo`**          | `string`           |
# **`created_at`**    | `datetime`         | `not null`
# **`updated_at`**    | `datetime`         | `not null`
# **`user_id`**       | `bigint(8)`        |
#
# ### Indexes
#
# * `index_deposits_on_user_id`:
#     * **`user_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`user_id => users.id`**
#

require 'rails_helper'

RSpec.describe Deposit, type: :model do
  describe "#withdrawn_amount" do
    let!(:user) { create(:user) }
    subject { deposit.reload.amount.positive? }

    context "when deposit amount is positive" do
      let!(:deposit) { build(:deposit, user: user) }
      before { deposit.save! }
      it "amount is positive" do
        expect(subject).to be_truthy
      end
    end

    context "when deposit amount is negative" do
      let!(:deposit) { build(:deposit, user: user) }
      before do
        deposit.amount = -10000
        deposit.save!
      end
      it "amount is positive" do
        expect(subject).to be_truthy
      end
    end

    context "when withdrawn amount is positive" do
      let!(:deposit) { build(:deposit, :withdrawn, user: user) }
      before do
        deposit.amount = 10000
        deposit.save!
      end
      it "amount is negative" do
        expect(subject).to be_falsey
      end
    end

    context "when withdrawn amount is negative" do
      let!(:deposit) { build(:deposit, :withdrawn, user: user) }
      before do
        deposit.save!
      end
      it "amount is negative" do
        expect(subject).to be_falsey
      end
    end
  end
end
