module BotsHelper
  def bot_embed_code(bot, width: 500, height: 500)
    "<iframe width=\"#{width}\" height=\"#{height}\" src=\"#{chats_url(bot.token)}\" style=\"border:solid 1px #c0c0c0;\" allowfullscreen></iframe>"
  end

  def monthly_guest_messages(guest_messages_summarizer)
    guest_messages_summarizer.data_between(
      1.month.ago.beginning_of_day,
      1.day.ago.end_of_day
    )
  end
end
