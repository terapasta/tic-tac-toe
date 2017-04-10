module Message::AnswerMarkable
  extend ActiveSupport::Concern

  included do
    scope :answer_marked, -> {
      where(answer_marked: true)
    }

    validate :answer_marked_validate, on: :update
  end

  def save_to_answer_marked
    self.answer_marked = true
    save
  end

  def save_to_remove_answer_marked
    self.answer_marked = false
    save
  end

  private
    def answer_marked_validate
      if answer_marked_changed?
        unless bot?
          errors.add(:answer_marked, 'はBot以外のメッセージでは変更できません。')
        end
      end
    end
end
