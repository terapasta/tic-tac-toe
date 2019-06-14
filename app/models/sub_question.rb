class SubQuestion < ApplicationRecord
  belongs_to :question_answer
  validates :question, presence: true
  validates_with SubQuestionValidator

  before_validation { self.question = question.strip }

  def sub_question?
    true
  end
end
