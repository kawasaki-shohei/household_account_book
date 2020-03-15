# ## Schema Information
#
# Table name: `budgets`
#
# ### Columns
#
# Name               | Type               | Attributes
# ------------------ | ------------------ | ---------------------------
# **`id`**           | `bigint(8)`        | `not null, primary key`
# **`amount`**       | `integer`          |
# **`created_at`**   | `datetime`         | `not null`
# **`updated_at`**   | `datetime`         | `not null`
# **`category_id`**  | `bigint(8)`        |
# **`user_id`**      | `bigint(8)`        |
#
# ### Indexes
#
# * `index_budgets_on_category_id`:
#     * **`category_id`**
# * `index_budgets_on_user_id`:
#     * **`user_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`category_id => categories.id`**
# * `fk_rails_...`:
#     * **`user_id => users.id`**
#

require 'rails_helper'

RSpec.describe Budget, type: :model do
  describe "Validation Check" do
    let!(:user) { create(:user) }
    let!(:category) { create(:own_category, user: user) }

    context "when no budget for the category" do
      let(:budget) { build(:budget, amount: 10000, user: user, category: category) }
      it "can save" do
        expect(budget.save).to be_truthy
      end
    end

    context "when exist one budget for the category" do
      let!(:budget1) { create(:budget, amount: 10000, user: user, category: category) }
      let!(:budget2) { build(:budget, amount: 20000, user: user, category: category) }
      it "new budget for the category cannot save" do
        expect(budget2.valid?).to be_falsey
        expect(budget2.errors[:base]).to eq([I18n.t('budget.validation.no_multiple_records')])
      end

      it "can update" do
        expect(budget1.update(amount: 20000)).to be_truthy
      end
    end
  end
end
