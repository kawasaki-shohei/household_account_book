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
    when 'new', 'create', 'withdraw'
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

  def demo_btn
    if Rails.env.production?
      link_to 'デモアプリを試す', CONFIG[:demo_url], class: "btn btn-orange btn-block"
    elsif Rails.env.demo?
      link_to 'デモアプリを試す', demo_path, method: :post, class: "btn btn-orange btn-block", id: 'demo-btn', style: 'background-color: #cc7a3f; border-color: #cc7a3f;'
    else
      link_to 'デモアプリを試す', demo_path, method: :post, class: "btn btn-orange btn-block"
    end
  end

  def signup_url_according_to_environment
    if Rails.env.production? || Rails.env.demo?
      CONFIG[:production_url] + signup_path
    else
      signup_path
    end
  end

  def login_url_according_to_environment
    if Rails.env.production? || Rails.env.demo?
      CONFIG[:production_url] + login_path
    else
      login_path
    end
  end

  def root_url_according_to_environment
    if Rails.env.production? || Rails.env.demo?
      CONFIG[:production_url] + root_path
    else
      root_path
    end
  end
end
