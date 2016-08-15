class Training < ActiveRecord::Base
  has_many :training_messages
  belongs_to :bot

  def build_start_message
    answer = bot.start_answer
    TrainingMessage.new(speaker: 'bot', answer_id: answer.id, body: answer.body)
  end
end
