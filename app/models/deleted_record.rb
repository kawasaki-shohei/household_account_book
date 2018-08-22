# ## Schema Information
#
# Table name: `deleted_records`
#
# ### Columns
#
# Name               | Type               | Attributes
# ------------------ | ------------------ | ---------------------------
# **`id`**           | `bigint(8)`        | `not null, primary key`
# **`deleted_by`**   | `bigint(8)`        |
# **`record_meta`**  | `text`             | `not null`
# **`table_name`**   | `string`           |
# **`created_at`**   | `datetime`         | `not null`
# **`updated_at`**   | `datetime`         | `not null`
#
# ### Indexes
#
# * `index_deleted_records_on_deleted_by`:
#     * **`deleted_by`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`deleted_by => users.id`**
#

class DeletedRecord < ApplicationRecord
end
