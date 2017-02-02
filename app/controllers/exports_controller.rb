class ExportsController < ApplicationController
  include BotUsable
  before_action :authenticate_user!
  before_action :set_bot

  def index
  end

  def show
    question_answers = QuestionAnswersDecorator.new(@bot.question_answers)
    send_data question_answers.to_csv(encoding: params[:encoding].to_sym),
      filename: "myope-exports-#{params[:encoding]}-#{Time.zone.now.strftime('%Y-%m-%d-%H%M%S')}.csv",
      type: :csv
  end

  private
    def set_bot
      @bot = bots.find(params[:bot_id])
    end
end
