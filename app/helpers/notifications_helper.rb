module NotificationsHelper
  def notifying_func(msg)
    case msg.func
    when "expenses"
      func = "出費"
    when "repeat_expenses"
      func = "繰り返し出費"
    when "wants"
      func = "欲しいものリスト"
    when "bought_buttons"
      func = "欲しいものリストのアイテム"
    when "categories"
      func = "カテゴリ"
    when "pays"
      func = "手渡し記録"
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
    end
    return act
  end
end
