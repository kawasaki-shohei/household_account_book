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

require 'rails_helper'

RSpec.describe CategoryMaster, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
