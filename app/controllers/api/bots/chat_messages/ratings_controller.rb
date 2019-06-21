class Api::Bots::ChatMessages::RatingsController < Api::BaseController
  include ApiRespondable
  include ApiChatOperable
  include ResourceSerializable

  def create
    guest_key = params.require(:guest_key)
    token = params.require(:bot_token)
    
    bot = Bot.find_by!(token: token)
    chat = bot.chats.find_by!(guest_key: guest_key)
    message = chat.messages.bot.find(params[:chat_message_id])

    if params[:rating][:level] == 'good'
      message.good!
    elsif params[:rating][:level] == 'bad'
      message.bad!
    end

    ChatChannel.broadcast_to(chat, {
      action: :rating,
      data: serialize(message.rating)
    })
  end
end