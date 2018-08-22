class MessageSummarizeController < ApplicationController
  include BotUsable
  include QuestionAnswersSearchable
  before_action :set_bot, only: [:index]

  def index
    @per_page = 20
    @keyword = params[:keyword]
    @current_page = current_page
    @qa = search_question_answers_count_list(
      bot: @bot,
      keyword: @keyword,
      q: params[:q],
      page: @current_page,
      per_page: @per_page
    )
    @question_answers = @qa.result
    @top_message = first_of_messages_count_having_question_answer(bot: @bot)
  end

  private
    def set_bot
      @bot = bots.find(params[:bot_id])
      authorize @bot
    end
end