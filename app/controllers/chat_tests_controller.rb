class ChatTestsController < ApplicationController
  include Replyable
  include BotUsable
  before_action :set_bot

  def new
  end

  def create
    respond_to do |format|
      format.html do
        if params[:file].blank? || File.extname(params[:file].path) != ".csv"
          redirect_to new_bot_chat_test_path(@bot), alert: 'csvファイルを選択してください。'
          return
        end

        ActiveRecord::Base.transaction do
          @chat = Chat.build_with_user_role(@bot)
          @chat.save
          option = params[:commit].include?('UTF-8') ? {} : { encoding: "Shift_JIS:UTF-8" }
          CSV.foreach(params[:file].path, option) do |csv_data|
            create_message(csv_data)
          end
          raise ActiveRecord::Rollback
        end
        @bot_test_results = Message.build_for_bot_test(@chat)
      end

      format.csv do
        file_data = JSON.parse(params[:file_data])
        option = params[:encode].include?('UTF-8') ? Encoding::CP65001 : Encoding::SJIS
        csv = CSV.generate(force_quotes: true, encoding: option) { |csv|
          file_data.each do |data|
            set_data = [data[0], data[1]]
            csv << set_data
          end
        }
        send_data csv, type: :csv, filename: "test_result.csv"
      end
    end
  end

  private
    def set_bot
      @bot = bots.find params[:bot_id]
    end

    def create_message(string)
      message = @chat.messages.create!(body: string[0]) {|m|
        m.speaker = 'guest'
        m.user_agent = request.env['HTTP_USER_AGENT']
      }
      receive_and_reply!(@chat, message)
    end
end
