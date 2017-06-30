class ChatTestsController < ApplicationController
  include Replyable
  include BotUsable
  before_action :set_bot

  def new
  end

  def create
    if params[:file].present? && File.extname(params[:file].path) == ".csv"
      ActiveRecord::Base.transaction do
        @chat = Chat.build_with_user_role(@bot)
        @chat.save

        if params[:commit].include?('UTF-8')
          CSV.foreach(params[:file].path) do |csv_data|
            build_message(csv_data)
          end
        else
          CSV.foreach(params[:file].path, encoding: "Shift_JIS:UTF-8") do |csv_data|
            build_message(csv_data)
          end
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

    def build_message(csv_data)
      message = @chat.messages.create!(body: csv_data[0]) {|m|
        m.speaker = 'guest'
        m.user_agent = request.env['HTTP_USER_AGENT']
      }
      receive_and_reply!(@chat, message)
    end
end
