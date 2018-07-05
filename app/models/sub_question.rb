class SubQuestion < ApplicationRecord
  belongs_to :question_answer
  validates :question, presence: true

  def sub_question?
    true
  end
end
