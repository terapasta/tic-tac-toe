module BotsHelper
  def bot_embed_code(bot, width: 500, height: 500)
    "<iframe width=\"#{width}\" height=\"#{height}\" src=\"#{chats_url(bot.token)}\" style=\"border:solid 1px #c0c0c0;\" allowfullscreen></iframe>"
  end
end
