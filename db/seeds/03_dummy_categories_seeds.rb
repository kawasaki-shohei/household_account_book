
categories = []
both_kinds = %w(家賃 食費 ガス代 電気代 水道代)
both_kinds.each do |kind|
  categories << Category.new(
    kind: kind,
    user_id: User.first.id,
    common: true
  )
end
ones_kinds = %w(交通費 交際費 保険代 医療費)
ones_kinds.each do |kind|
  categories << Category.new(
    kind: kind,
    user_id: User.first.id,
    common: true
  )
end
#FIXME パートナーの自分のカテゴリも登録


Category.import categories


