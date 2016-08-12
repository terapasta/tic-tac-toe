class ChatsController < ApplicationController
  before_action :set_chat, only: [:show, :destroy]
  before_action :set_bot, only: [:new, :destroy]
  before_action :set_guest_key

  def show
    session[:embed] = params[:embed] if params[:embed]
    redirect_to new_chats_path if @chat.nil?
  end

  def new
    @chat = @bot.chats.new(guest_key: session[:guest_key])
    @chat.messages << Message.start_message
    @chat.save!
    render :show
  end

  def destroy
    flash[:notice] = 'クリアしました'
    redirect_to new_bot_chats_path(@bot)
  end

  private
    def set_bot
      # HACK URL内のIDを変更すれば、他社のbotも表示出来てしまうため、いずれはトークンなどによるbot識別をする必要がある
      @bot = Bot.find(params[:bot_id])
    end

    def set_chat
      @chat = Chat.where(guest_key: session[:guest_key]).last
    end

    def set_guest_key
      session[:guest_key] ||= SecureRandom.hex(64)
    end

    def message_params
      params.require(:message).permit(:body)
    end
end
