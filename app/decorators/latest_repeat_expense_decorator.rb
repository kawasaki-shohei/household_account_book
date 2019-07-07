module LatestRepeatExpenseDecorator
  include RepeatExpenseDecorator

  def gray_out
    end_date < Date.current ? "over-end-date" : ""
  end
end
