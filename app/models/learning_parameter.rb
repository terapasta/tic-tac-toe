class LearningParameter < ActiveRecord::Base
  belongs_to :bot

  enum algorithm: { :logistic_regression, :naive_bayes }
end
