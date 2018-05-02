class SubQuestion < ApplicationRecord
  belongs_to :question_answer
  validates :question, presence: true

  before_validation do
    wakatify_question.tap do |wq|
      if question_answer.try(:bot).try(:present?)
        wq = WordMapping.for_bot(question_answer.bot).decorate.replace_synonym(wq)
      end
      self.question_wakati = wq
    end
  end

  def wakatify_question
    Wakatifier.apply(question)
  end
end
