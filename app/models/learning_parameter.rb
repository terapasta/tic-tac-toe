class LearningParameter < ApplicationRecord
  belongs_to :bot

  enum algorithm: [
    :logistic_regression,
    :naive_bayes,
    :neural_network,
    :similarity_classification,
    :two_step_similarity_classification,
    :word2vec_wmd,
    :hybrid_classification,
  ]

  enum alrorithm_for_feedback: [
    :none,
    :rocchio,
  ]

  def use_similarity_classification?
    similarity_classification? or two_step_similarity_classification?
  end

  def self.default_attributes
      {
        algorithm: algorithms[:similarity_classification],
        parameters: {},
        alrorithm_for_feedback: alrorithm_for_feedbacks[:rocchio],
        parameters_for_feedback: {},
        classify_threshold: 0.5,
      }
  end

  def self.build_with_default
    new(default_attributes)
  end

  def attributes
    {
      algorithm: LearningParameter.algorithms[algorithm],
      alrorithm_for_feedback: LearningParameter.alrorithm_for_feedbacks[alrorithm_for_feedback],
    }
  end
end
