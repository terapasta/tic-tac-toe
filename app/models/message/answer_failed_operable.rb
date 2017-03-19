module AnswerFailedOperable
  extend ActiveSupport::Concern

  included do
    scope :answer_failed, -> {
      where(answer_failed: true)
    }

    validate :answer_failed_validate, on: :update
  end

  def save_to_answer_failed
    self.answer_failed = true
    self.answer_failed_by_user = true
    save
  end

  def save_to_answer_succeed
    self.answer_failed = false
    self.answer_failed_by_user = false
    save
  end

  private
    def answer_failed_validate
      if answer_failed_changed?
        unless bot?
          errors[:only_bot_message_allowed_answer_status_changing] << 'Bot以外のメッセージの回答ステータスは変更できません'
        end

        unless answer_failed?
          if answer_failed_was && answer_failed_by_user_was == false
            errors[:only_answer_failed_by_user] << 'ユーザーが失敗に変更した回答のみ回答成功に変更できます。'
          end

          if answer_failed_by_user?
            errors[:irregular_answer_failed_by_user] << 'ユーザーによる回答失敗状態のまま回答成功に変更できません。'
          end
        end
      end
    end
end
