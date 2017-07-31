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
  def material_icon(name, options = {})
    klass = options.delete(:class)
    options.merge!(class: "material-icons #{klass}")
    content_tag(:i, name, options)
  end

  def nl2br(text)
    sanitize(text.to_s).gsub(/\r?\n/, '<br />').html_safe
  end

  def pagination_items_count(resources, current_page, per_page)
    (
      content_tag(:span, "全#{resources.total_count}件") +
      content_tag(:span, " | ") +
      if current_page == 1
        content_tag(:span, 1)
      else
        content_tag(:span, (current_page - 1) * per_page + 1)
      end +
      content_tag(:span, "〜#{resources.count}件を表示中")
    ).html_safe
  end

  def topic_tags_for_select(bot)
    null_topic_tag = Struct.new(:id, :name).new(-1, 'トピックタグなし')
    [null_topic_tag, *bot.topic_tags]
  end

  def mixpanel_event_data(event_name, bot)
    { data: { event_name: event_name, bot_id: bot.id, bot_name: bot.name } }
  end

  def unstarted_tasks_count
    @_unstarted_tasks_count ||= Task.unstarted(@bot).count
  end

  def done_tasks_count
    @_done_tasks_count ||= Task.where(bot_id: @bot.id).with_done(true).count
  end

  def class_names(hash = {})
    hash.map{ |class_name, use| class_name if use }.compact.join(' ')
  end
end
