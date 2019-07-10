# ## Schema Information
#
# Table name: `pays`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `bigint(8)`        | `not null, primary key`
# **`amount`**      | `integer`          |
# **`date`**        | `date`             |
# **`memo`**        | `string`           |
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
# **`user_id`**     | `bigint(8)`        |
#
# ### Indexes
#
# * `index_pays_on_user_id`:
#     * **`user_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`user_id => users.id`**
#

class Pay < ApplicationRecord
  belongs_to :user

  validates :amount, :date, presence: true
  validates_length_of :amount, maximum: 10
  validates_length_of :memo, maximum: 100

  scope :newer, -> {order(date: :desc, created_at: :desc)}

  def self.ones_all_payment(user)
    user.pays.sum(:amount)
  end

  def self.ones_gross(user)
    user.expenses.until_last_month.both_t.sum(:amount) + ones_all_payment(user)
  end

  def self.get_couple_pays(user)
    self.eager_load(:user).where(users: {id: [user, user.partner]}).newer
  end

  def self.must_pay(current_user, partner)
    current_user.expenses.until_last_month.both_t.sum(:mypay) + partner.expenses.until_last_month.both_t.sum(:partnerpay)
  end

  def self.balance_of_gross(current_user, partner)
    my_gross = ones_gross(current_user)
    my_must_pay = must_pay(current_user, partner)
    my_must_pay - my_gross + ones_all_payment(partner)
  end

end
