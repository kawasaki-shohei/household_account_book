module ApplicationHelper
  include SessionsHelper, UsersHelper

  def submit_btn_letters
    case action_name
    when 'new', 'withdraw'
      return '入力'
    when 'edit'
      return '編集'
    else
      return '送信'
    end
  end
end
