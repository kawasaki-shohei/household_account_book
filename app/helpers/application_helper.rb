module ApplicationHelper

  def submit_btn_letters
    case action_name
    when 'new', 'withdraw'
      return '入力'
    when 'edit'
      return '更新'
    else
      return '送信'
    end
  end

  def active_side_menu(*keyword)
    keyword.include?(controller_name) ? "active" : ""
  end

  def partner_mode
    session[:partner_mode] ? 'active' : ''
  end

  def partner_mode_http_method
    session[:partner_mode] ? :delete : :post
  end

end
