module CategoryDecorator
  def common_btn
    if common
      icon = content_tag(:i, "", class: "fa fa-lg fa-star")
      link_to icon, common_category_path(self), method: :delete, remote: true, data:{confirm: "共通カテゴリーからしますが、よろしいでしょうか？"}, class: "text-redpaper space-left"
    else
      icon = content_tag(:i, "", class: "fa fa-lg fa-star-o")
      link_to icon, common_category_path(self), method: :patch, remote: true, data:{confirm: "共通カテゴリーに登録しますが、よろしいでしょうか？"}, class: "text-redpaper space-left"
    end
  end

  def common_mark
    return nil unless common
    icon = content_tag(:i, "", class: "fa fa-exchange")
    content_tag(:small, icon + ' 共通', class: "label bg-orange")
  end

  def cancel_btn
    link_to cancel_categories_path(id: self), remote: true, class: "text-red" do
      content_tag(:i, "", class: "fa fa-2x fa-times-circle")
    end
  end

  def own_expenses_sum(user)
    expenses.select{ |e| e.is_own_expense?(user) }.sum(&:amount)
  end

  def own_both_expenses_mypay_sum(user)
    expenses.select{ |e| e.is_both_expense_paid_by?(user) }.sum(&:mypay)
  end

  def partner_both_expenses_partnerpay_sum(user)
    expenses.select{ |e| e.is_both_expense_paid_by?(user.partner) }.sum(&:partnerpay)
  end

  def expenses_sum(user)
    own_expenses_sum(user) + own_both_expenses_mypay_sum(user) + partner_both_expenses_partnerpay_sum(user)
  end

end
