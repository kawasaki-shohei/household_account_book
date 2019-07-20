user = User.first
partner = user.partner
own_category_masters = CategoryMaster.where(is_common: false).order(:id)
own_common_category_masters, partner_common_category_masters = CategoryMaster.where(is_common: true).partition { |cm| cm.id.even? }

def create_copied_category(user, category_masters)
  category_masters.each do |cm|
    user.categories.create!(
      name: cm.name,
      is_common: cm.is_common,
      category_master_id: cm.id
    )
  end
end

ActiveRecord::Base.transaction do
  # 自分だけのカテゴリーを登録
  create_copied_category(user, own_category_masters)
  create_copied_category(partner, own_category_masters)
  # 共通のカテゴリーを登録
  create_copied_category(user, own_common_category_masters)
  create_copied_category(partner, partner_common_category_masters)
end


