# ## Schema Information
#
# Table name: `latest_repeat_expenses`
#
# ### Columns
#
# Name                  | Type               | Attributes
# --------------------- | ------------------ | ---------------------------
# **`id`**              | `bigint(8)`        |
# **`amount`**          | `integer`          |
# **`deleted_at`**      | `datetime`         |
# **`end_date`**        | `date`             |
# **`is_for_both`**     | `boolean`          |
# **`memo`**            | `string`           |
# **`mypay`**           | `integer`          |
# **`partnerpay`**      | `integer`          |
# **`percent`**         | `integer`          |
# **`repeat_day`**      | `integer`          |
# **`start_date`**      | `date`             |
# **`updated_period`**  | `integer`          |
# **`created_at`**      | `datetime`         |
# **`updated_at`**      | `datetime`         |
# **`category_id`**     | `bigint(8)`        |
# **`item_id`**         | `integer`          |
# **`item_sub_id`**     | `integer`          |
# **`user_id`**         | `bigint(8)`        |
#

require 'rails_helper'

RSpec.describe LatestRepeatExpense, type: :model do
  before do
    @user1 = create(:user_with_partner)
    @category1 = create(:own_category, user: @user1)
    @user2 = @user1.partner
    category2 = create(:own_category, user: @user2)

    @user3 = create(:user_with_partner)
    category3 = create(:own_category, user: @user3)
    @user4 = @user3.partner
    category4 = create(:own_category, user: @user4)

    create_list(:repeat_expense, 5, user: @user1, category: @category1)
    create(:repeat_expense, user: @user2, category: category2, item_id: 1)
    create(:repeat_expense, user: @user3, category: category3, item_id: 1)
    create(:repeat_expense, user: @user4, category: category4, item_id: 1)
  end

  it "has all users latest_repeat_expenses" do
    first_repeat_expense = @user1.repeat_expenses.first
    item_id = first_repeat_expense.item_id
    create(:repeat_expense, user: @user1, category: @category1, item_id: item_id, item_sub_id: 2)

    user1_latest_repeat_expenses_size = LatestRepeatExpense.where(user_id: @user1.id).size
    expect(user1_latest_repeat_expenses_size).to eq(5)

    exist_users = LatestRepeatExpense.all.pluck(:user_id).uniq.sort
    expect(exist_users).to eq ([@user1.id, @user2.id, @user3.id, @user4.id].sort)
  end
end
