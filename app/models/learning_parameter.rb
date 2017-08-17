class LearningParameter < ActiveRecord::Base
  serialize :params_for_algorithm, JSON

  belongs_to :bot

  enum algorithm: [ :logistic_regression, :naive_bayes ]

  def self.default_attributes
      {
        algorithm: algorithms[:logistic_regression],
        params_for_algorithm: {},
        classify_threshold: 0.5,
        use_similarity_classification: true,
      }
  end

  def self.build_with_default
    new(default_attributes)
  end
end
