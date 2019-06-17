class SubQuestion < ApplicationRecord
  belongs_to :question_answer
  validates :question, presence: true
  validates_with SubQuestionValidator

  before_validation { self.question = question.strip }

  after_destroy do
    self.question_answer.bot.learn_later
  end

  def sub_question?
    true
  end
end
