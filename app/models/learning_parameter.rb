class LearningParameter < ActiveRecord::Base
  serialize :params_for_algorithm, JSON

  belongs_to :bot

  enum algorithm: [ :logistic_regression, :naive_bayes ]

  def self.default_attributes
      {
        algorithm: algorithms[:naive_bayes],
        params_for_algorithm: {},
        include_failed_data: false,  # FIXME include_failed_dataは現在は使用されていないので削除したい
        include_tag_vector: false,
        classify_threshold: 0.5,
        use_similarity_classification: false,
      }
  end

  def self.build_with_default
    new(default_attributes)
  end
end
