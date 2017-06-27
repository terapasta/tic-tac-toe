module ThreadsHelper
  def role_filter_params(param = {})
    message_params.merge param
  end

  def message_filter_params(param = {})
    role_params.merge param
  end

  def threads_filter_li(filter_name, &block)
    is_active = params[filter_name].present?
    content_tag(:li, capture(&block), class: ('active' if is_active))
  end

  def threads_filter_link(filter_name, event_name, bot, &block)
    link_to \
      capture(&block),
      bot_threads_path(bot, params: message_filter_params(filter_name => 1)),
      mixpanel_event_data(event_name, bot)
  end

  private
    def message_params
      @message_params ||= params.slice(:filter, :good, :bad, :answer_marked)
    end

    def role_params
      @role_params ||= params.slice(:normal)
    end
end
