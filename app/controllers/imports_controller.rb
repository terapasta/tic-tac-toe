class ImportsController < ApplicationController
  include BotUsable
  before_action :set_bot

  def show
  end

  def create
    importer = QuestionAnswer.import_csv(params[:file], @bot, import_options)
    if importer.succeeded
      @bot.learn_later
      redirect_to bot_imports_path, notice: 'インポートしました'
    else
      flash.now.alert = 'インポートに失敗しました'
      @error_row = importer.current_row
      @error_message = importer.error_message
      render :show
    end
  end

  private
    def set_bot
      @bot = bots.find(params[:bot_id])
    end

    def import_options
      { is_utf8: params[:commit]&.include?('UTF-8') }
    end
end
