module ExpenseDecorator
  def show_date(expenses, current_user, index)
    if index == 0 || date != expenses[index - 1].date
      expenses_of_the_date = expenses.select{ |e| e.date == date }
      sum_of_the_date = category.expenses_sum(expenses_of_the_date, current_user)
      content_tag(:li, class: "time-label") do
        concat content_tag(:span, l(date, format: :long), class: "bg-orange")
        concat (
                 content_tag(:small, class: "sum-of-the-date") do
                   concat "合計 "
                   concat tag.i(class: "fa fa-cny")
                   concat " #{sum_of_the_date.to_s(:delimited)}"
                 end
               )
      end
    end
  end

  def necessary_pay_of(user)
    self.user == user ? mypay : partnerpay
  end

  def check_mark(user)
    if self.user == user
      tag.i(class: "fa fa-check-square-o space-right text-orange")
    end
  end
end
