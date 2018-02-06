class Badget < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validate :check_one_category

  def check_one_category
    if action_name == "create"
      check = Badget.find_by(user_id: user_id, category_id: category_id)
      if check.present?
        errors[:base] << "同じカテゴリーに２つの予算を設定できません。予算を編集してください。"
      end
    end
  end

end
