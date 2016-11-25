module BotsHelper
  def bot_embed_code(bot)
    "<iframe width=\"500\" height=\"500\" src=\"#{chats_url(bot.token)}\" style=\"border:solid 1px #c0c0c0;\" allowfullscreen></iframe>"
  end

  def learning_status_label(bot)
    class_name = case
      when bot.processing?
        'warning'
      when bot.failed?
        'danger'
      when bot.successed?
        'success'
      end

    content_tag :label, class: "label label-#{class_name}", 'data-toggle': 'tooltip', title: l(bot.learning_status_changed_at) do
      bot.learning_status_i18n
    end
  end
end
