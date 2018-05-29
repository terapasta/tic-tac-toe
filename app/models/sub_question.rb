class SubQuestion < ApplicationRecord
  belongs_to :question_answer
  validates :question, presence: true

  before_validation :set_question_wakati

  def set_question_wakati
    if question_answer&.bot.present?
      word_mappings = WordMapping.for_bot(question_answer.bot).decorate
      self.question_wakati = word_mappings.replace_synonym(Wakatifier.apply(question))
    else
      self.question_wakati = Wakatifier.apply(question)
    end
  end

  def sub_question?
    true
  end
end
