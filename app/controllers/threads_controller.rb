class ThreadsController < ApplicationController
  include BotUsable
  before_action :authenticate_user!
  before_action :set_bot

  def index
    @chats = @bot.chats
      .has_multiple_messages
      .not_staff(!current_user.staff?)
      .has_answer_failed(params[:filter])
      .has_good_answer(params[:good])
      .has_bad_answer(params[:bad])
      .page(params[:page])

    respond_to do |format|
      format.html
      format.csv do
        send_data BotThreadsMessagesDecorator.new(@chats).to_csv(encoding: :sjis),
                  filename: "myope-threads-exports-#{params[:encoding]}-#{Time.zone.now.strftime('%Y-%m-%d-%H%M%S')}.csv",
                  type: :csv
      end
    end
  end

  private
    def set_bot
      @bot = bots.find_by!(id: params[:bot_id])
    end
end
