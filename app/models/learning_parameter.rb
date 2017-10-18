class LearningParameter < ActiveRecord::Base
  serialize :params_for_algorithm, JSON

  belongs_to :bot

  enum algorithm: [
    :logistic_regression,
    :naive_bayes,
    :neural_network,
    :similarity_classification,
    :two_step_similarity_classification,
  ]

  def use_similarity_classification?
    similarity_classification? or two_step_similarity_classification?
  end

  def self.default_attributes
      {
        algorithm: algorithms[:similarity_classification],
        params_for_algorithm: {},
        classify_threshold: 0.5,
      }
  end

  def self.build_with_default
    new(default_attributes)
  end
end
