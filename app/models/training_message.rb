class TrainingMessage < ActiveRecord::Base
  belongs_to :training
  belongs_to :answer
  enum speaker: { bot: 'bot', guest: 'guest' }
  enum context: { normal: 'normal', contact: 'contact' }

  def parent
    training
  end
end
