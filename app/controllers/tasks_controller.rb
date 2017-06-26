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
      redirect_to bot_tasks_path(@bot)
    else
      redirect_to bot_tasks_path(@bot), alert: '対応済みにできませんでした'
    end
  end

  private
    def set_bot
      @bot = Bot.find(params[:bot_id])
    end
end
