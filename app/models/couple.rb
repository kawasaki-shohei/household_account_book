# ## Schema Information
#
# Table name: `couples`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `bigint(8)`        | `not null, primary key`
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
# **`partner_id`**  | `bigint(8)`        |
# **`user_id`**     | `bigint(8)`        |
#
# ### Indexes
#
# * `index_couples_on_partner_id` (_unique_):
#     * **`partner_id`**
# * `index_couples_on_user_id` (_unique_):
#     * **`user_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`partner_id => users.id`**
# * `fk_rails_...`:
#     * **`user_id => users.id`**
#

class Couple < ApplicationRecord

  attr_accessor :new_record

  belongs_to :user
  belongs_to :partner, class_name: 'User'
  validates_uniqueness_of :user_id, :partner_id

  def register_partner!(partner_email)
    partner = User.find_by!(email: partner_email)
    assign_attributes(partner: partner)
    save!
  end

end
