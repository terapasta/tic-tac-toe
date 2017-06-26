class ChatTestsController < ApplicationController
  include Replyable
  include BotUsable
  before_action :set_bot

  def new
  end

  def create
    if File.extname(params[:file].path) == ".csv"
      ActiveRecord::Base.transaction do
        @chat = Chat.build_chat_from_csv_data(@bot)
        @chat.save

        CSV.foreach(params[:file].path) do |csv_data|
          message = @chat.messages.create!(body: csv_data[0]) {|m|
            m.speaker = 'guest'
            m.user_agent = request.env['HTTP_USER_AGENT']
          }
          receive_and_reply!(@chat, message)
        end
        raise ActiveRecord::Rollback
      end
    else
      redirect_to new_bot_chat_test_path(@bot), alert: 'csvファイルを選択してください。'
    end
  end

  private
    def set_bot
      @bot = bots.find params[:bot_id]
    end
end
