class Training < ActiveRecord::Base
  has_many :training_messages, dependent: :destroy
  belongs_to :bot

  alias_method :messages, :training_messages  # chatとtrainingで同じように振る舞えるようにするために別名をつける

  def build_start_message
    body = bot.start_message.presence || DefinedAnswer.start_answer_unsetting.body
    TrainingMessage.new(speaker: 'bot', answer_id: nil, body: body)
  end

  # Chatモデルとインターフェースを揃えるため
  def guest_key
    nil
  end
end
