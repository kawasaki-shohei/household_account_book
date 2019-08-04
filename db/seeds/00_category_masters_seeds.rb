# Category.where.not(category_master_id: nil).update_all(category_master_id: nil)
# CategoryMaster.all&.destroy_all

CategoryMaster.create!(id: 1, name: I18n.t('category_master.name.food'), is_common: true)
CategoryMaster.create!(id: 2, name: I18n.t('category_master.name.convenience_goods'), is_common: true)
CategoryMaster.create!(id: 3, name: I18n.t('category_master.name.data'), is_common: true)
CategoryMaster.create!(id: 4, name: I18n.t('category_master.name.utility'), is_common: true)
CategoryMaster.create!(id: 5, name: I18n.t('category_master.name.living'), is_common: true)
CategoryMaster.create!(id: 6, name: I18n.t('category_master.name.entertainment'), is_common: true)
CategoryMaster.create!(id: 7, name: I18n.t('category_master.name.big_expense'), is_common: true)
CategoryMaster.create!(id: 8, name: I18n.t('category_master.name.others'), is_common: true)

CategoryMaster.create!(id: 9, name: I18n.t('category_master.name.transportation'), is_common: false)
CategoryMaster.create!(id: 10, name: I18n.t('category_master.name.entertainment_expense'), is_common: false)
CategoryMaster.create!(id: 11, name: I18n.t('category_master.name.learning'), is_common: false)
CategoryMaster.create!(id: 12, name: I18n.t('category_master.name.medical'), is_common: false)
CategoryMaster.create!(id: 13, name: I18n.t('category_master.name.beauty'), is_common: false)