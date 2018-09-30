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
  pending "add some examples to (or delete) #{__FILE__}"
end
