module QuestionAnswersSearchable
  extend ActiveSupport::Concern

  included do
    helper_method :sorting_url
  end

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

    def sorting_url(condition)
      send(index_path_helper_name, @bot, request.query_parameters.merge(q: { s: condition }))
    end

    def index_path_helper_name
      fail 'Must implement this method'
    end
end
