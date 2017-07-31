class DummyMLEngine
  def initialize(bot)
  end

  def reply(body)
    {
      results: [],
      question_feature_count: 0,
      question: "",
      status_code: 101,
      probability: 1,
      answer_id: 0
    }.with_indifferent_access
  end
end
