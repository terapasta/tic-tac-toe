class TrainingMessage < ActiveRecord::Base
  belongs_to :training
  enum speaker: { bot: 'bot', guest: 'guest' }
end
