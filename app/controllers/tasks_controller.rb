class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bot
  before_action :set_task

  def index
  end

  def update
    task = @tasks.find(params[:id])
    task.is_done = true
    task.save
    redirect_to bot_tasks_path(@bot)
  end

  private
    def set_bot
      @bot = Bot.find(params[:bot_id])
    end

    def set_task
      @tasks = Task.where(bot_id: params[:bot_id]).with_done(params[:done]).page(params[:page]).per(20).order(:created_at)
    end
end
