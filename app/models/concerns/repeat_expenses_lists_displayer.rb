module RepeatExpensesListsDisplayer
  def is_own_expense?(user, category=self.category)
    !is_for_both? && self.user == user && self.category == category
  end
end