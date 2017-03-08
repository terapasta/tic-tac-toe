class Message < ActiveRecord::Base
  paginates_per 50

  attr_accessor :other_answers

  belongs_to :chat
  belongs_to :answer

  enum speaker: { bot: 'bot', guest: 'guest' }
  enum rating: [:nothing, :good, :bad]

  validates :body, length: { maximum: 10000 }
  validate :answer_failed_validate, on: :update

  scope :answer_failed, -> {
    where(answer_failed: true)
  }

  def parent
    chat
  end

  def to_training_message_attributes
    {
      answer_id: answer_id,
      speaker: speaker,
      body: body,
    }
  end

  def speaker_image_url
    if bot?
      parent.bot.image_url
    elsif guest?
      'silhouette.png'
    else
      'operator'
    end
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
          errors.add('Bot以外のメッセージの回答ステータスは変更できません。')
        end
        if !answer_failed? && answer_failed_was == true && answer_failed_by_user_was == false
          errors.add('ユーザーが失敗に変更した回答のみ回答成功に変更できます。')
        end
      end
    end
end
