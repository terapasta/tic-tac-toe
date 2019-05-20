class TasksController < ApplicationController
  include BotUsable
  before_action :set_bot

  def show
    @task = @bot.tasks.find(params[:id])
  end

  def index
    @unstarted_tasks_count = Task.unstarted(@bot).count
    @done_tasks_count = Task.where(bot_id: @bot.id).with_done(true).count
    @per_page = 20
    @is_normal_index = params[:done].blank? && params[:action] == 'index'
    
    @tasks = @bot.tasks
      .with_done(params[:done])
      .page(page)
      .per(@per_page)
      .order(created_at: :desc)
    if @tasks.count.zero? && page > 1
      redirect_to bot_tasks_path(@bot)
    end
  end

  def update
    @task = @bot.tasks.find(params[:id])
    if @task.update(is_done: (params[:is_done] || true).to_bool)
      if params[:redirect_path].present?
        redirect_to params[:redirect_path]
      else
        redirect_back fallback_location: bot_tasks_path(@bot)
      end
    else
      redirect_back fallback_location: bot_tasks_path(@bot), alert: '対応状態を変更できませんでした'
    end
  end

  private
    def set_bot
      @bot = bots.find(params[:bot_id])
    end

    def page
      (params[:page] || 1).to_i
    end
end
