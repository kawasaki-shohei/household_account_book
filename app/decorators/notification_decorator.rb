module NotificationDecorator

  def object_made_notification
    object_attributes = record_meta
    notification_message.func.classify.constantize.new(object_attributes)
  end

  def link
    case notification_message.func
    when "expenses"
      expenses_path(
        category_id: object_made_notification.category_id,
        period: object_made_notification.date.to_s_as_year_month,
        expense: object_made_notification.id
      )
    when "repeat_expenses"
      repeat_expenses_path
    when "categories"
      categories_path
    when "pays"
      pays_path
      # when "wants", "bought_buttons"
      #   wants_path
    end
  end

  # todo: カテゴリーのアイコン機能がついたら修正
  def icon
    case notification_message.func
    when "expenses"
      tag.i(class: "fa fa-shopping-cart")
    when "repeat_expenses"
      tag.i(class: "fa fa-repeat")
    when "categories"
      tag.i(class: "fa fa-list-ul")
    when "pays"
      tag.i(class: "fa fa-yen")
    when "deposits"
      tag.i(class: "fa fa-bank")
    end
  end

  def heading
    "#{user.name}さんが#{translate_func}を#{translate_act}しました。"
  end

  def translate_func
    t("notification.func.#{notification_message.func}")
  end

  def translate_act
    t("notification.act.#{notification_message.act}")
  end

end
