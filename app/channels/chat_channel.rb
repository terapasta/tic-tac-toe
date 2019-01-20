class ChatChannel < ApplicationCable::Channel
  def subscribed
    @bot = Bot.find_by!(token: params[:bot_token])
    @chat = @bot.chats.find_by!(guest_key: params[:guest_key])
    unless ChatPolicy.new(current_user, @chat).show?
      fail 'cannot authorized'
    end
    stream_for @chat
  end
end