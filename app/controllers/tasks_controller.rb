class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bot

  def index
    @tasks = @bot.tasks
      .with_done(params[:done])
      .page(params[:page])
      .per(20)
      .order(:created_at)
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
      @bot = Bot.find(params[:bot_id])
    end
end
