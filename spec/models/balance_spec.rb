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
# **`month`**       | `string`           |
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
# **`user_id`**     | `bigint(8)`        |
#
# ### Indexes
#
# * `index_balances_on_user_id`:
#     * **`user_id`**
# * `index_balances_on_user_id_and_month` (_unique_):
#     * **`user_id`**
#     * **`month`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`user_id => users.id`**
#

require 'rails_helper'

RSpec.describe Balance, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
