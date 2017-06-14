module QuestionAnswerSearchable
  extend ActiveSupport::Concern

  private
    def search_question_answer(bot)
      q = bot.question_answers
        .topic_tag(params.dig(:topic, :id))
        .includes(:decision_branches)
        .order('question')
        .page(params[:page])
        .keyword(params[:keyword])
        .search(params[:q])
    end
end
