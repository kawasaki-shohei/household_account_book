# ## Schema Information
#
# Table name: `incomes`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `bigint(8)`        | `not null, primary key`
# **`amount`**      | `integer`          |
# **`date`**        | `date`             |
# **`memo`**        | `string`           |
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
# **`user_id`**     | `bigint(8)`        |
#
# ### Indexes
#
# * `index_incomes_on_user_id`:
#     * **`user_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`user_id => users.id`**
#

require 'rails_helper'

RSpec.describe Income, type: :model do
  describe "Validation Check" do
    before do
      @user = create(:user_with_partner)
    end

    it "is valid with amount, date and user" do
      income = Income.new(
        amount: 1000,
        date: Date.current,
        user: @user
      )
      expect(income).to be_valid
    end

    it "is invalid without user" do
      income = Income.new(
        amount: 1000,
        date: Date.current,
        user: nil
      )
      expect(income).to be_invalid
      expect(income.errors.full_messages.size).to eq(1)
    end

    it "is invalid without amount" do
      income = Income.new(
        amount: nil,
        date: Date.current,
        user: @user
      )
      expect(income).to be_invalid
      expect(income.errors.full_messages.size).to eq(2)
    end

    it "is valid with 9 digits amount" do
      income = Income.new(
        amount: 9999999999,
        date: Date.current,
        user: @user
      )
      expect(income).to be_valid
    end

    it "is valid with 10 digits amount" do
      income = Income.new(
        amount: 10000000000,
        date: Date.current,
        user: @user
      )
      expect(income).to be_invalid
      expect(income.errors.full_messages.size).to eq(1)
    end
  end
end
