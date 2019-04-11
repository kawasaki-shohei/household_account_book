module ApplicationHelper

  def submit_btn_letters
    case action_name
    when 'new', 'withdraw'
      return '登録'
    when 'edit'
      return '更新'
    else
      return '送信'
    end
  end

end
