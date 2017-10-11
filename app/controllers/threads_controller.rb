class ThreadsController < ApplicationController
  include BotUsable
  before_action :authenticate_user!
  before_action :set_bot

  def index
    @per_page = 20
    tmp_chats = @bot.chats
      .has_multiple_messages
      .not_staff(!current_user.staff?)
      .not_normal(params[:normal].blank?)
      .normal(params[:normal])
      .has_answer_failed(params[:answer_failed].to_bool)
      .has_good_answer(params[:good].to_bool)
      .has_bad_answer(params[:bad].to_bool)
      .has_answer_marked(params[:marked].to_bool)

    if current_user.ec_plan?(@bot) && params[:normal].blank?
      tmp_chats = tmp_chats.where('chats.created_at >= ?', current_user.histories_limit_time(@bot))
    end

    @chats = tmp_chats
      .page(params[:page])
      .per(@per_page)

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
