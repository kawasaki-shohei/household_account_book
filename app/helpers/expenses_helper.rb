module ExpensesHelper
  def percent_selection
    selection = { '半分' => 1, '3分の1' => 2, '3分の2' => 3, '相手100%' => 4 }
    return selection
  end

  def which_percent(val)
    percent_selection.key(val)
  end

end
