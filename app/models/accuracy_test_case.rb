class AccuracyTestCase < ActiveRecord::Base
  belongs_to :bot

  validates :question_text, presence: true
end
