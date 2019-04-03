class CategoryDecorator < Draper::Decorator
  delegate_all

  # @return [badget]
  def current_user_badget
    badgets.find{ |badget| badget.try(:user_id) == h.current_user.id }
  end

end
