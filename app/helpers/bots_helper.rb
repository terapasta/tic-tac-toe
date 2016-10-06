module BotsHelper
  def bot_embed_code(bot)
    "<iframe width=\"500\" height=\"500\" src=\"#{chats_url(bot.token)}\" style=\"border:solid 1px #c0c0c0;\" allowfullscreen></iframe>"
  end
end
