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
    
    @per_page = 20
    @all_question_answers = @bot.question_answers.order('messages_count DESC')
    @question_answers = @all_question_answers
      .page(params[:page])
      .per(@per_page)
    @top_message = @all_question_answers.first

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
