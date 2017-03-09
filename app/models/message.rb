class Message < ActiveRecord::Base
  paginates_per 50

  attr_accessor :other_answers, :similar_question_answers

  belongs_to :chat
  belongs_to :answer

  enum speaker: { bot: 'bot', guest: 'guest' }
  enum rating: [:nothing, :good, :bad]

  validates :body, length: { maximum: 10000 }

  scope :answer_failed, -> {
    where(answer_failed: true)
  }

  scope :exchanging_messages_count, -> {
    # 質問1つに回答が1つ返ってきた状態を対話数とカウントするのでguestの質問数=対話数とみなせる。
    where('speaker = ?', speakers[:guest]).count()
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
end
