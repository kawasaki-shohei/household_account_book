module ExpenseDecorator
  def own_expense?(user)
    self.user == user
  end

  def partner_expense?(user)
    self.user == user.partner
  end
end
