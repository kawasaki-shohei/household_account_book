module ApplicationHelper

  def render_react_component(*args, &block)
    content_for :webpacker_assets do
      assets = []
      assets << javascript_pack_tag('application')
      assets << stylesheet_pack_tag('application')
      assets.join("\n").html_safe
    end
    react_component(*args, &block)
  end

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
    session[:patner_mode] ? 'active' : ''
  end

  def partner_mode_http_method
    session[:patner_mode] ? :delete : :post
  end

end
