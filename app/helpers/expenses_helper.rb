module ExpensesHelper
  def percent_selection
    selection = { '半分' => 0.5, '3分の1' => 0.33, '3分の2' => 0.66, '相手100%' => 0.0 }
    return selection
  end

  def which_percent(val)
    percent_selection.key(val)
  end

end
