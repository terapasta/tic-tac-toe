class Tasks::BulkCompletesController < ApplicationController
  include BotUsable

  def create
    @bot = bots.find(params[:bot_id])
    @tasks = @bot.tasks.where(id: params[:task_ids].split(','))
    ActiveRecord::Base.transaction do
      @tasks.each(&:done!)
    end
    respond_to do |format|
      format.html { back }
      format.json { render json: {}, status: :no_content }
    end
  rescue => e
    logger.error e.message
    respond_to do |format|
      format.html { back(alert: 'エラーが発生し、対話タスクを対応済みにできませんでした') }
      format.json { render json: {}, status: :unprocessable_entity }
    end
  end

  private
    def back(options = {})
      redirect_back({ fallback_location: bot_tasks_path(@bot) }.merge(options))
    end
end