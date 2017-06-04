module QuestionAnswerSearchable
  extend ActiveSupport::Concern

  private
    def search_question_answer
      @topic_tags = @bot.topic_tags
      @search_result = params.dig(:topic, :id)
      @keyword = params[:keyword]
      @q = @bot.question_answers
        .topic_tag(params.dig(:topic, :id))
        .includes(:decision_branches)
        .order('question')
        .page(params[:page])
        .keyword(params[:keyword])
        .search(params[:q])
      @question_answers = @q.result
    end
end
