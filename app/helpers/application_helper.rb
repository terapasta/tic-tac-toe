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

  def logo_class
    # https://www.pivotaltracker.com/story/show/162403437
    # 市民のミカタ（OEM)対応のため、暫定的な処置としてアドレスをベタ打ち
    if current_user.email == "milai-work@little-cloud.jp"
      "mikata"
    else
      ""
    end
  end

  def page_title
    # https://www.pivotaltracker.com/story/show/162403437
    # 市民のミカタ（OEM)対応のため、暫定的な処置としてアドレスをベタ打ち
    if current_user&.email == "milai-work@little-cloud.jp"
      "市民のミカタ - 問い合わせ専用AIチャットボット"
    else
      "My-ope office - 社内問い合わせ専用AIチャットボット"
    end
  end
end
