class ChatTestsController < ApplicationController
  include Replyable
  include BotUsable
  before_action :set_bot

  def new
  end

  def create
    unless params[:file].present? && File.extname(params[:file].path) == ".csv"
      redirect_to new_bot_chat_test_path(@bot), alert: 'csvファイルを選択してください。'
    end

    ActiveRecord::Base.transaction do
      @chat = Chat.build_with_user_role(@bot)
      @chat.save
      option = params[:commit].include?('UTF-8')? {} : { encoding: "Shift_JIS:UTF-8" }
      CSV.foreach(params[:file].path, option) do |csv_data|
        build_message(csv_data)
      end
      raise ActiveRecord::Rollback
    end
  end

  private
    def set_bot
      @bot = bots.find params[:bot_id]
    end

    def build_message(csv_data)
      message = @chat.messages.create!(body: csv_data[0]) {|m|
        m.speaker = 'guest'
        m.user_agent = request.env['HTTP_USER_AGENT']
      }
      receive_and_reply!(@chat, message)
    end
end
