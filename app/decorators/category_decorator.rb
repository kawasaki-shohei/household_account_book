module CategoryDecorator
  def common_btn
    if common
      icon = content_tag(:i, "", class: "fa fa-lg fa-star")
      link_to icon, common_category_path(self), method: :delete, remote: true, data:{confirm: "共通カテゴリーからしますが、よろしいでしょうか？"}, class: "text-redpepper space-left"
    else
      icon = content_tag(:i, "", class: "fa fa-lg fa-star-o")
      link_to icon, common_category_path(self), method: :patch, remote: true, data:{confirm: "共通カテゴリーに登録しますが、よろしいでしょうか？"}, class: "text-redpepper space-left"
    end
  end

  def common_mark
    return nil unless common
    icon = content_tag(:i, "", class: "fa fa-exchange")
    content_tag(:small, icon + ' 共通', class: "label bg-orange")
  end

  def cancel_btn
    link_to cancel_categories_path(id: self), remote: true, class: "text-redpepper" do
      content_tag(:i, "", class: "fa fa-2x fa-times-circle")
    end
  end

  def own_expenses_sum(expenses, user)
    expenses.select{ |e| e.is_own_expense?(user, self) }.sum(&:amount)
  end

  def own_both_expenses_mypay_sum(expenses, user)
    expenses.select{ |e| e.is_both_expense_paid_by?(user, self) }.sum(&:mypay)
  end

  def partner_both_expenses_partnerpay_sum(expenses, user)
    expenses.select{ |e| e.is_both_expense_paid_by?(user.partner, self) }.sum(&:partnerpay)
  end

  def expenses_sum(expenses, user)
    own_expenses_sum(expenses, user) + own_both_expenses_mypay_sum(expenses, user) + partner_both_expenses_partnerpay_sum(expenses, user)
  end

  def percentage(expenses, user, total)
    (expenses_sum(expenses, user) * 100).fdiv(total)
  end

end
