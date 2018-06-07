class ThreadsController < ApplicationController
  include BotUsable
  before_action :set_bot

  def index
    respond_to do |format|
      format.html do
        @per_page = 20
        @guest_messages = @bot.messages.includes(:bot_messages)

        if !params[:answer_failed].to_bool && !params[:good].to_bool && !params[:bad].to_bool && !params[:marked].to_bool
          @guest_messages = @guest_messages.guest
        end

        @guest_messages = @guest_messages
          .is_staff_message(!current_user.staff?)
          .has_answer_failed_or_bad_or_good_or_marked_answer(params[:answer_failed].to_bool, params[:good].to_bool, params[:bad].to_bool, params[:marked].to_bool)
          .is_normal_message(params[:normal].present?)
          .order(created_at: :desc)
          .page(params[:page]).per(@per_page)

        render :index
      end

      format.csv do
        chats = @bot.chats
          .includes(messages: [:rating])
          .not_staff(!current_user.staff?)
          .not_normal(params[:normal].to_bool)

        if current_user.ec_plan?(@bot) && params[:normal].blank?
          chats = chats.where('chats.created_at >= ?', current_user.histories_limit_time(@bot))
        end

        decorated_chats = BotThreadsMessagesDecorator.new(chats)
        raw_csv = decorated_chats.to_csv(encoding: :sjis)
        filename = "myope-threads-exports-sjis-#{Time.zone.now.strftime('%Y-%m-%d-%H%M%S')}.csv"
        send_data raw_csv, filename: filename, type: :csv
      end
    end
  end

  private
    def set_bot
      @bot = bots.find_by!(id: params[:bot_id])
    end
end
