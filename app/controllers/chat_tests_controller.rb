class ChatTestsController < ApplicationController
  include Replyable
  before_action :set_bot
  before_action :set_chat, only: [:show]

  def new
  end

  def create
    # ↓リファクトします
    if File.extname(params[:file].path) == ".csv"
      @chat = @bot.chats.build(guest_key: SecureRandom.hex(64))
      @chat.is_staff = true if current_user.try(:staff?)
      @chat.is_normal = true if current_user.try(:normal?)
      @chat.save
      CSV.foreach(params[:file].path) do |data|
        @message = @chat.messages.create!(body: data[0]) {|m|
          m.speaker = 'guest'
          m.user_agent = request.env['HTTP_USER_AGENT']
        }
        receive_and_reply!(@chat, @message)
      end
      redirect_to bot_chat_test_path(@bot, @chat)
    else
      redirect_to new_bot_chat_test_path(@bot), alert: 'csvファイルを選択してください。'
    end
  end

  def show
  end

  private
    def set_bot
      @bot = Bot.find(params[:bot_id])
    end

    def set_chat
      @chat = Chat.find(params[:id].to_i)
    end
end
