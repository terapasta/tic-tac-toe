class TrainingMessagesController < ApplicationController
  before_action :authenticate_user!
  # before_action :set_chat, only: [:show, :destroy]
  before_action :set_bot
  # before_action :set_guest_key
  # before_action :set_warning_message
  #
  def index
    respond_to do |format|
      format.csv do
        send_data TrainingMessage.to_csv(@bot), filename: 'training_messages.csv', type: :csv
      end
    end
  end
  #
  # def new
  #   @chat = @bot.chats.new(guest_key: session[:guest_key])
  #   @chat.messages << @chat.build_start_message
  #   @chat.save!
  #   render :show
  # end
  #
  # def destroy
  #   flash[:notice] = 'クリアしました'
  #   redirect_to new_bot_chats_path(@bot)
  # end
  #
  private
    def set_bot
      @bot = current_user.bots.find(params[:bot_id])
    end
  #
  #   def set_chat
  #     @chat = Chat.where(guest_key: session[:guest_key]).last
  #   end
  #
  #   def set_guest_key
  #     session[:guest_key] ||= SecureRandom.hex(64)
  #   end
  #
  #   def set_warning_message
  #     return false unless @bot.id == 2  # botがハナコさんのときのみデモ情報を表示する
  #     flash[:warning] = "本デモでは以下のオペレーションに対して回答することが出来ます。\n・カードキーなくした\n・パソコンが壊れた、ログインができない\n・今週の予定どうなってますか？\n・総務の山田さんに連絡をとりたい"
  #   end
  #
  #   def message_params
  #     params.require(:message).permit(:body)
  #   end
end
