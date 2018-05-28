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
  rescue QuestionAnswer::CsvImporter::InvalidUTF8Error => e
    flash.now.alert = 'UTF-8でインポートできませんでした。Shift_JISをお試しください。'
    render :show
  rescue QuestionAnswer::CsvImporter::InvalidSJISError => e
    flash.now.alert = 'Shift_JISでインポートできませんでした。UTF-8をお試しください。'
    render :show
  end

  private
    def set_bot
      @bot = bots.find(params[:bot_id])
    end

    def import_options
      { is_utf8: params[:commit]&.include?('UTF-8') }
    end
end
