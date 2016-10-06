class EmbedController < ApplicationController
  def show
    @bot = Bot.find_by(token: params[:token])
    # @chat = @bot.chats.new(guest_key: session[:guest_key])
    # @chat.messages << @chat.build_start_message
    # @chat.save!
  end
end
