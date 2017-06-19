module QuestionAnswersSearchable
  extend ActiveSupport::Concern

  private
    def search_question_answers(bot:, topic_id:, keyword:, q:, page:, per_page:)
      bot.question_answers
        .topic_tag(topic_id)
        .includes(:decision_branches)
        .order(created_at: :desc)
        .page(page)
        .per(per_page)
        .keyword(keyword)
        .search(q)
    end
end
