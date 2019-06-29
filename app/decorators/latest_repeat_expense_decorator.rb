module LatestRepeatExpenseDecorator
  include RepeatExpenseDecorator

  def gray_out
    e_date < Date.current ? "over-end-date" : ""
  end
end
