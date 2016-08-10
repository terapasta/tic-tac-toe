class BotsController < ApplicationController
  # before_action :set_chat, only: [:show, :destroy]
  # before_action :set_guest_key
  #
  def index
    @bots = current_user.bots
  end

  # def show
  #   session[:embed] = params[:embed] if params[:embed]
  #   redirect_to new_chats_path if @chat.nil?
  # end
  #
  # def new
  #   @chat = Chat.new(guest_key: session[:guest_key])
  #   @chat.messages << Message.start_message
  #   @chat.save!
  #   render :show
  # end
  #
  # def destroy
  #   flash[:notice] = 'クリアしました'
  #   redirect_to new_chats_path
  # end
  #
  # private
  #   def set_chat
  #     @chat = Chat.where(guest_key: session[:guest_key]).last
  #   end
  #
  #   def set_guest_key
  #     session[:guest_key] ||= SecureRandom.hex(64)
  #   end
  #
  #   def message_params
  #     params.require(:message).permit(:body)
  #   end
end
