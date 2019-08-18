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

  def preview_btn
    if Rails.env.production?
      link_to 'プレビュー', CONFIG[:preview_url], class: "btn btn-orange btn-block"
    else
      link_to 'プレビュー', preview_path, method: :post, class: "btn btn-orange btn-block", id: 'preview-btn'
    end
  end

  def signup_url_according_to_environment
    if Rails.env.production? || Rails.env.preview?
      CONFIG[:production_url] + signup_path
    else
      signup_path
    end
  end

  def login_url_according_to_environment
    if Rails.env.production? || Rails.env.preview?
      CONFIG[:production_url] + login_path
    else
      login_path
    end
  end

  def root_url_according_to_environment
    if Rails.env.production? || Rails.env.preview?
      CONFIG[:production_url] + root_path
    else
      root_path
    end
  end
end
