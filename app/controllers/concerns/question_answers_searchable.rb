module QuestionAnswersSearchable
  extend ActiveSupport::Concern

  included do
    helper_method :sorting_url
  end

  private
    def search_question_answers(bot:, topic_id:, keyword:, q:, page:, per_page:, without_ids: [])
      result = bot.question_answers
        .topic_tag(topic_id)
        .includes(:decision_branches, :topic_tags, :sub_questions, :answer_files)
        .order(created_at: :desc)
        .page(page)
        .per(per_page)
        .keyword(keyword)
      result = result.where.not(id: without_ids) if without_ids.present?
      result.search(q)
      raise
    end

    def search_question_answers_count_list(bot:, keyword:, q:, page:, per_page:)
      result = bot.question_answers
        .order('messages_count DESC')
        .page(page)
        .per(per_page)
        .keyword(keyword)
      result.search(q)
    end

    def first_of_messages_count_having_question_answer(bot:)
      bot.question_answers
        .order(messages_count: :desc)
        .limit(1)
        .first
    end

    def sorting_url(condition)
      send(index_path_helper_name, @bot, request.query_parameters.merge(q: { s: condition }))
    end

    def index_path_helper_name
      fail 'Must implement this method'
    end
end
