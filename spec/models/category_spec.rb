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
  pending "add some examples to (or delete) #{__FILE__}"
end
