class TrainingMessage < ActiveRecord::Base
  include ContextHoldable

  belongs_to :training
  belongs_to :answer
  enum speaker: { bot: 'bot', guest: 'guest' }
  enum context: ContextHoldable::CONTEXTS

  def parent
    training
  end
end
