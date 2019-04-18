module ExpenseDecorator
  def show_date(expenses, index)
    if index == 0 || self.date != expenses[index - 1].date
      content_tag(:li, class: "time-label") do
        concat content_tag(:span, l(date, format: :long), class: "bg-orange")
      end
    end
  end
end
