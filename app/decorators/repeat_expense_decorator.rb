module RepeatExpenseDecorator
  include CommonDecorator
  include ExpenseDecorator

  def default_date(date_name)
    if action_name == 'edit' || action_name == 'update'
      send("#{date_name}")
    else
      Date.current
    end
  end
end
