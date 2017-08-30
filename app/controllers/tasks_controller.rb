class TasksController < ApplicationController
  include BotUsable
  before_action :authenticate_user!
  before_action :set_bot

  def index
    @unstarted_tasks_count = Task.unstarted(@bot).count
    @done_tasks_count = Task.where(bot_id: @bot.id).with_done(true).count
    @per_page = 20

    @tasks = @bot.tasks
      .with_done(params[:done])
      .page(params[:page])
      .per(@per_page)
      .order(created_at: :asc)
  end

  def update
    @task = @bot.tasks.find(params[:id])
    if @task.update(is_done: true)
      if params[:redirect_to_new_question_answer_form].to_bool
        redirect_to new_bot_question_answer_path(@bot, question: @task.guest_message, answer: @task.bot_message)
      else
        redirect_to bot_tasks_path(@bot)
      end
    else
      redirect_to bot_tasks_path(@bot), alert: '対応済みにできませんでした'
    end
  end

  private
    def set_bot
      @bot = bots.find(params[:bot_id])
    end
end
