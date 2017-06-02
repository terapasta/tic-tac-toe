module ApplicationHelper
  def space(length = 1)
    ('&nbsp;' * length).html_safe
  end

  def need_side_nav?
    !chat_page? && policy(:static_pages).can_use_nav?(@bot)
  end

  def root_container_class
    return if params[:action] == "headless"
    "container container-main".tap do |result|
      if need_side_nav?
        result << ""
      end
    end
  end

  def embed_js_url
    if Rails.env.development?
      "http://#{request.env['HTTP_HOST']}/assets/embed.js"
    else
      "#{ActionController::Base.asset_host}/assets/embed.js"
    end
  end
end
