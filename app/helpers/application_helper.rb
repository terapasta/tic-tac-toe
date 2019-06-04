module ApplicationHelper
  def space(length = 1)
    ('&nbsp;' * length).html_safe
  end

  def embed_js_url
    if Rails.env.development?
      "http://#{request.env['HTTP_HOST']}/assets/embed.js"
    else
      "#{ActionController::Base.asset_host}/assets/embed.js"
    end
  end

  def material_icon(name, options = {})
    klass = options.delete(:class)
    options.merge!(class: "material-icons #{klass}")
    content_tag(:i, name, options)
  end

  def nl2br(text)
    sanitize(text.to_s.squeeze("\n")).gsub(/\r?\n/, '<br />').html_safe
  end

  def unescape_backslash(text)
    text.gsub(/\\/,'\\\\\\')
  end

  def topic_tags_for_select(bot)
    null_topic_tag = Struct.new(:id, :name).new(-1, 'トピックタグなし')
    [null_topic_tag, *bot.topic_tags]
  end

  def class_names(hash = {})
    hash.map{ |class_name, use| class_name if use }.compact.join(' ')
  end

  def css_bg_image(url)
    "background-image:url(#{url});"
  end

  def logo_class(bot = nil)
    # https://www.pivotaltracker.com/story/show/162403437
    # 管理者画面に対応
    provides_to_little_cloud?(bot) ? "mikata" : ""
  end

  def page_title(bot = nil)
    # https://www.pivotaltracker.com/story/show/162403437
    # 管理者画面とチャット画面に対応
    default_title = "My-ope office - 社内問い合わせ専用AIチャットボット"

    provides_to_little_cloud?(bot) ? "市民のミカタ - 問い合わせ専用AIチャットボット" : default_title
  end

  def provides_to_little_cloud?(bot = nil)
    current_user&.little_cloud_worker? || bot&.little_cloud_bot?
  end
end
