class BotsController < ApplicationController
  include BotUsable
  before_action :set_bot, only: [:show, :edit, :update, :reset]

  def index
    @bots = bots.all.includes(organizations: [:users])
    redirect_to bot_path(@bots.first) if @bots.count == 1
  end

  def show
    @today_chats_count = @bot.chats.today_count_of_guests
    unless current_user.staff?
      @chats_limit = current_user.chats_limit_per_day(@bot)
      @progress = ((@today_chats_count.to_f / @chats_limit.to_f) * 100).round
    end

    if current_user.staff?
      @recent_30days_users_count = @bot.chats.count_of_guests_within(30.days.ago, Time.current)
      @total_reducted_minutes = @recent_30days_users_count * 5
      @reducted_hours = @total_reducted_minutes / 60
      @reducted_minutes = @total_reducted_minutes % 60
    end

    @guest_messages_summarizer = GuestMessagesSummarizer.new(@bot)
    @bad_count_summarizer = BadCountSummarizer.new(@bot)
  end

  def reset
    @bot.reset_training_data!
    flash[:notice] = '学習データをリセットしました'
    redirect_to [:edit, @bot]
  end

  private
    def set_bot
      @bot = bots.find(params[:id])
      authorize @bot
    end
end
