module CategoryDecorator

  # todo: カテゴリーアイコンの機能ができたら修正
  def icon
    content_tag(:td, class: "text-center td-middle no-padding") do
     concat(
       content_tag(:span, class: "category-circle mushroom") do
         concat tag.i(class: "fa fa-lg fa-shopping-cart")
       end
     )
    end
  end

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

  def history_title(period)
    period.to_japanese_year_month + kind + "の履歴"
  end

  # @return [Integer]
  def own_expenses_sum(expenses, user)
    expenses.select{ |e| e.is_own_expense?(user, self) }.sum(&:amount)
  end

  # @note 二人の出費の内、mypayの合計額
  # @return [Integer]
  def own_both_expenses_mypay_sum(expenses, user)
    expenses.select{ |e| e.is_both_expense_paid_by?(user, self) }.sum(&:mypay)
  end

  # @note 二人の出費の内、partnerのpartnerpayの合計額
  # @return [Integer]
  def partner_both_expenses_partnerpay_sum(expenses, user)
    expenses.select{ |e| e.is_both_expense_paid_by?(user.partner, self) }.sum(&:partnerpay)
  end

  # @note 二人の出費の合計額
  # @return [Integer]
  def both_expenses_sum(expenses, user)
    own_both_expenses_mypay_sum(expenses, user) + partner_both_expenses_partnerpay_sum(expenses, user)
  end

  # @note 自分の出費の合計額と二人の出費の合計額の和
  # @return [Integer]
  def expenses_sum(expenses, user)
    own_expenses_sum(expenses, user) + both_expenses_sum(expenses, user)
  end

  def percentage(expenses, user, total)
    (expenses_sum(expenses, user) * 100).fdiv(total)
  end

  # @return [Integer]
  # @note 予算を設定していないときは0を返す
  def badget_amount(user)
    badgets.find{ |b| b.user == user }.try(:amount) || 0
  end

  def badget_balance(expense_amount, user)
    badget_amount(user) - expense_amount
  end

end
