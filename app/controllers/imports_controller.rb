class ImportsController < ApplicationController
  include BotUsable
  before_action :authenticate_user!
  before_action :set_bot

  def new
  end

  def create
    importer = QuestionAnswer.import_csv(params[:file], @bot, import_options)
    if importer.succeeded
      @bot.learn_later
      flash.now.notice = 'インポートしました'
    else
      flash.now.alert = 'インポートに失敗しました'
      @error_row = importer.current_row
      @error_message = importer.error_message
    end
    render :new
  end

  private
    def set_bot
      @bot = bots.find(params[:bot_id])
    end

    def import_options
      { is_utf8: params[:commit]&.include?('UTF-8') }
    end

    # def bot_params
    #   params.require(:bot).permit(:name, :image)
    # end
end
