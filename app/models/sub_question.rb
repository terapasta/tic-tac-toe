class SubQuestion < ApplicationRecord
  belongs_to :question_answer
  validates :question, presence: true

  before_validation do
    Wakatifier.apply(question).tap do |wq|
      if question_answer.try(:bot).try(:present?)
        wq = WordMapping.for_bot(question_answer.bot).decorate.replace_synonym(wq)
      end
      self.question_wakati = wq
    end
  end
end
