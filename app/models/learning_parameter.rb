class LearningParameter < ApplicationRecord
  belongs_to :bot

  enum algorithm: [
    :logistic_regression, # 0
    :naive_bayes, # 1
    :neural_network, # 2
    :similarity_classification, # 3
    :two_step_similarity_classification, # 4
    :word2vec_wmd, # 5
    :hybrid_classification, # 6
    :topic_similarity_classification, # 7
    :fuzzy_similarity_classification, # 8
  ]

  enum feedback_algorithm: [
    :disable,
    :rocchio,
    :rocchio_nearlest_centroid,
  ]

  def use_similarity_classification?
    similarity_classification? || two_step_similarity_classification? || fuzzy_similarity_classification? || topic_similarity_classification?
  end

  def self.default_attributes
      {
        algorithm: algorithms[:fuzzy_similarity_classification],
        parameters: {},
        feedback_algorithm: feedback_algorithms[:disable],
        parameters_for_feedback: {},
        classify_threshold: 0.6,
      }
  end

  def self.build_with_default
    new(default_attributes)
  end

  def attributes
    {
      algorithm: LearningParameter.algorithms[algorithm],
      feedback_algorithm: LearningParameter.feedback_algorithms[feedback_algorithm],
    }
  end
end
