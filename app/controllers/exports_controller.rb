class ExportsController < ApplicationController
  include BotUsable
  before_action :authenticate_user!
  before_action :set_bot
  before_action :set_question_answers, only: [:create]

  def index
    @exports = @bot.exports.order(created_at: :desc).page(params[:page]).per(10)
  end

  def create
    @file_body = @question_answers.to_csv(encoding: params[:encoding])
    @export = @bot.exports.build(encoding: params[:encoding])

    @export.with_tmp_file(file_body: @file_body, extension: 'csv') do |file|
      @export.file = file
      if @export.save
        redirect_to bot_exports_path(@bot), notice: 'エクスポートファイルを作成しました'
      else
        flash.now.alert = 'エクスポートファイルを作成できませんでした'
        render :index
      end
    end
  end

  private
    def set_bot
      @bot = bots.find(params[:bot_id])
      authorize @bot, :show?
    end

    def set_question_answers
      @question_answers = @bot.question_answers.decorate
    end
end
