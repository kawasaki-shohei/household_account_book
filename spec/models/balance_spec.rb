# ## Schema Information
#
# Table name: `balances`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `bigint(8)`        | `not null, primary key`
# **`amount`**      | `integer`          |
# **`period`**      | `string`           |
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
# **`user_id`**     | `bigint(8)`        |
#
# ### Indexes
#
# * `index_balances_on_user_id`:
#     * **`user_id`**
# * `index_balances_on_user_id_and_period` (_unique_):
#     * **`user_id`**
#     * **`period`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`user_id => users.id`**
#

require 'rails_helper'

RSpec.describe Balance, type: :model do
  describe "Validation Check" do
    before do
      @user = create(:user)
    end
    
    it "is valid with amount, period, user" do
      balance = Balance.new(
        amount: 1000,
        period: "2019-01",
        user: @user
      )
      expect(balance).to be_valid
    end

    it "is invalid without amount" do
      balance = Balance.new(
        amount: nil,
        period: "2019-01",
        user: @user
      )
      expect(balance).to be_valid
    end
  end
end
