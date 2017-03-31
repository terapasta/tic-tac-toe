module AnswerMarkable
  extend ActiveSupport::Concern

  included do
    scope :answer_marked, -> {
      where(answer_marked: true)
    }

    validate :answer_marked_validate, on: :update
  end

  def save_to_answer_marked
    self.answer_failed_by_user = true
    save
  end

  def save_to_remove_answer_marked
    self.answer_failed_by_user = false
    save
  end

  private
    def answer_marked_validate
      if answer_failed_by_user_changed?
        unless bot?
          errors.add(:answer_failed_by_user, 'はBot以外のメッセージでは変更できません。')
        end
      end
    end
end
