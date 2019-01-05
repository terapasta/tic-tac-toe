class ChatChannel < ApplicationCable::Channel
  def subscribed
    bot = Bot.find_by(token: params[:bot_token])
  end
end