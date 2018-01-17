class DummyMLEngine
  def initialize(bot)
  end

  def replies(bodies)
    {
      data: bodies.map{ |body|
        {
          results: @@dummy_results,
          question_feature_count: 0,
          question: body,
          status_code: 101,
          probability: 1,
          answer_id: 0
        }.with_indifferent_access
      }
    }
  end

  def reply(body)
    {
      results: @@dummy_results,
      question_feature_count: 0,
      question: body,
      status_code: 101,
      probability: 1,
      answer_id: 0
    }.with_indifferent_access
  end

  @@dummy_results = []

  def self.add_dummy_result(probability:, question_answer_id:)
    @@dummy_results.push(
      'probability' => probability,
      'question_answer_id' => question_answer_id
    )
  end

  def self.clear_dummy_results
    @@dummy_results = []
  end
end
