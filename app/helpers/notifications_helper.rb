module NotificationsHelper
  def notifying_func(msg)
    case msg.func
    when "expenses"
      func = "出費"
    when "repeat_expenses"
      func = "繰り返し出費"
    when "categories"
      func = "カテゴリ"
    when "pays"
      func = "手渡し記録"
    when "deposits"
      func = "二人の貯金"
    # when "wants"
    #   func = "欲しいものリスト"
    # when "bought_buttons"
    #   func = "欲しいものリストのアイテム"
    end
    return func
  end

  def notifying_act(msg)
    case msg.act
    when "create"
      act = "追加"
    when "update"
      act = "更新"
    when "destroy"
      act = "削除"
    when "bought"
      act = "購入"
    when "want"
      act = "未購入に戻"
    end
    return act
  end

  def notification_link(msg)
    case msg.func
    when "expenses"
      expenses_path(anchor: :partner_expenses)
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
end
