class LearningParameter < ActiveRecord::Base
  belongs_to :bot

  enum algorithm: [ :logistic_regression, :naive_bayes ]

  def self.default_attributes
      {
        algorithm: algorithms[:logistic_regression],  # TODO naive_bayesに変更する
        params_for_algorithm: {},
        include_failed_data: false,
        include_tag_vector: false,
        classify_threshold: 0.5,
      }
  end

  def self.build_with_default
    new(default_attributes)
  end
end
