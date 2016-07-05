class ChatsController < ApplicationController
  before_action :set_chat, only: :show

  def show
  end

  def new
    @chat = Chat.new(thread_key: 'DUMMY')
    @chat.messages << Message.start_message
    @chat.save!
    render :show
  end

  def destroy
    Chat.last.messages.destroy_all
    redirect_to new_chat_path
  end

  private
    def set_chat
      @chat = Chat.find(params[:id])
    end

    def message_params
      params.require(:message).permit(:body)
    end
end
