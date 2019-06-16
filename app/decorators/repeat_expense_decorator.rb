module RepeatExpenseDecorator
  include CommonDecorator
  include ExpenseDecorator

  def default_date(date_name)
    action_name == 'edit' ? send("#{date_name}") : Date.current
  end
end
