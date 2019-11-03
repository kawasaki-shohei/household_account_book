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
      expect(balance).to be_invalid
      expect(balance.errors.details).to eq({:amount=>[{:error=>:blank}]})
    end

    it "is invalid without user" do
      balance = Balance.new(
        amount: 1000,
        period: "2019-01",
        user: nil
      )
      expect(balance).to be_invalid
      expect(balance.errors.details).to eq({:user=>[{:error=>:blank}]})
    end

    it "is invalid without period" do
      balance = Balance.new(
        amount: 1000,
        period: nil,
        user: @user
      )
      expect(balance).to be_invalid
      expect(balance.errors.details).to eq({:period=>[{:error=>:blank}, {:error=>:invalid, :value=>nil}]})
    end

    it "is invalid with future_month" do
      balance = Balance.new(
        amount: 1000,
        period: Date.current.months_since(1).to_s_as_period,
        user: @user
      )
      expect(balance).to be_invalid
      expect(balance.errors[:base]).to eq([I18n.t('balance.validation.future_month_is_invalid')])
    end
  end
end
