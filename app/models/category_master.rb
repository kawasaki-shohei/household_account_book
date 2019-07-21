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

class CategoryMaster < ApplicationRecord
  has_many :categories
  validates :name, presence: true, length: { maximum: 15 }

  def attributes_without_id_and_timestamps
    attr = attributes.dup
    attr.delete("id")
    attr.delete("created_at")
    attr.delete("updated_at")
    attr
  end
end
