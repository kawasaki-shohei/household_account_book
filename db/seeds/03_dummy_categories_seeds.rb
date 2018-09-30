both_kinds = %w(家賃 食費 ガス代 電気代 水道代)
ones_kinds = %w(交通費 交際費 保険代 医療費)
user = User.first
partner = user.partner
@categories = []
def create_category_instance(kinds, user, common_flg)
  kinds.each do |kind|
    @categories << Category.new(
      kind: kind,
      user_id: user.id,
      common: common_flg
    )
  end
end
create_category_instance(both_kinds, user, true)
create_category_instance(ones_kinds, user, false)
create_category_instance(ones_kinds, partner, false)

Category.import @categories


