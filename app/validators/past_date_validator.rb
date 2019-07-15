class PastDateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value > Date.current
      record.errors[:base] << "未来日は入力できません。"
    end
  end
end