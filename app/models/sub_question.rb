class SubQuestion < ApplicationRecord
  belongs_to :question_answer
  validates :question, presence: true
  validates_with SubQuestionValidator

  def sub_question?
    true
  end
end
