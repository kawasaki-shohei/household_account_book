# ## Schema Information
#
# Table name: `category_masters`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `bigint(8)`        | `not null, primary key`
# **`is_common`**   | `boolean`          | `default(FALSE)`
# **`name`**        | `string`           | `not null`
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
#

FactoryBot.define do
  factory :category_master do
    
  end
end
