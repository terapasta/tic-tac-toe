class TrainingMessage < ActiveRecord::Base
  belongs_to :training
  belongs_to :answer
  enum speaker: { bot: 'bot', guest: 'guest' }
  enum context: { normal: 'normal', contact: 'contact' }

  def self.start_message
    answer = Answer.find(Answer::START_MESSAGE_ID)
    TrainingMessage.new(speaker: 'bot', answer_id: answer.id, body: answer.body)
  end

  def parent
    training
  end
end
