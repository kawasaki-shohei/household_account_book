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
# **`e_date`**          | `date`             |
# **`is_for_both`**     | `boolean`          |
# **`memo`**            | `string`           |
# **`mypay`**           | `integer`          |
# **`partnerpay`**      | `integer`          |
# **`percent`**         | `integer`          |
# **`r_date`**          | `integer`          |
# **`s_date`**          | `date`             |
# **`updated_period`**  | `integer`          |
# **`created_at`**      | `datetime`         |
# **`updated_at`**      | `datetime`         |
# **`category_id`**     | `bigint(8)`        |
# **`item_id`**         | `integer`          |
# **`item_sub_id`**     | `integer`          |
# **`user_id`**         | `bigint(8)`        |
#

FactoryBot.define do
  factory :latest_repeat_expense do
    
  end
end
