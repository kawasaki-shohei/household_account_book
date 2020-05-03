# ## Schema Information
#
# Table name: `categories`
#
# ### Columns
#
# Name                      | Type               | Attributes
# ------------------------- | ------------------ | ---------------------------
# **`id`**                  | `bigint(8)`        | `not null, primary key`
# **`is_common`**           | `boolean`          | `default(FALSE)`
# **`name`**                | `string`           |
# **`created_at`**          | `datetime`         | `not null`
# **`updated_at`**          | `datetime`         | `not null`
# **`category_master_id`**  | `bigint(8)`        |
# **`user_id`**             | `bigint(8)`        |
#
# ### Indexes
#
# * `index_categories_on_category_master_id`:
#     * **`category_master_id`**
# * `index_categories_on_user_id`:
#     * **`user_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`category_master_id => category_masters.id`**
# * `fk_rails_...`:
#     * **`user_id => users.id`**
#

require 'rails_helper'

RSpec.describe Category, type: :model do
  describe "Validation Check" do
    before do
      @user = create(:user_with_partner)
    end

    it "is valid with user and name" do
      category = Category.new(
        user: @user,
        name: Faker::Lorem.word,
      )
      expect(category).to be_valid
    end

    it "is invalid without user" do
      category = Category.new(
        user: nil,
        name: Faker::Lorem.word,
        )
      expect(category).to be_invalid
      expect(category.errors.full_messages.size).to eq(1)
    end

    it "is invalid without name" do
      category = Category.new(
        user: @user,
        name: nil,
        )
      expect(category).to be_invalid
      expect(category.errors.full_messages.size).to eq(1)
    end

    it "is valid with 15 letters name" do
      category = Category.new(
        user: @user,
        name: Faker::Lorem.characters(number: 15)
        )
      expect(category).to be_valid
    end

    it "is invalid with 16 letters name" do
      category = Category.new(
        user: @user,
        name: Faker::Lorem.characters(number: 16)
      )
      expect(category).to be_invalid
      expect(category.errors.full_messages.size).to eq(1)
    end
  end
end
