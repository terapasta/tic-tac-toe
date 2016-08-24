class Training < ActiveRecord::Base
  has_many :training_messages
  belongs_to :bot

  alias_method :messages, :training_messages  # chatとtrainingで同じように振る舞えるようにするために別名をつける

  def build_start_message
    answer = bot.start_answer
    TrainingMessage.new(speaker: 'bot', answer_id: answer.id, body: answer.body)
  end

  # Chatモデルとインターフェースを揃えるため
  def guest_key
    nil
  end
end
