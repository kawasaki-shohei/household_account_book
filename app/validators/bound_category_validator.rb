class BoundCategoryValidator < ActiveModel::Validator
  def validate(record)
    if record.is_for_both? && !record.category.is_common?
      record.errors[:base] << "二人の出費には共通のカテゴリーを選択してください。"
    end
  end
end