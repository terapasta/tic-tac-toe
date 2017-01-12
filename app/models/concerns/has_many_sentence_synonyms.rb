module HasManySentenceSynonyms
  extend ActiveSupport::Concern

  included do
    has_many :sentence_synonyms, dependent: :destroy, foreign_key: :training_message_id
    accepts_nested_attributes_for :sentence_synonyms
  end

  module ClassMethods
    def pick_sentence_synonyms_not_enough(bot, user)
      picking_sentence_synonyms(bot, user).sample
    end

    def picking_sentence_synonyms(bot, user)
      messages = begin
        if self == TrainingMessage
          bot.training_messages.guest.includes(:sentence_synonyms)
        elsif self == ImportedTrainingMessage
          bot.imported_training_messages.includes(:sentence_synonyms)
        end
      end
      messages.select {|m|
        m.sentence_synonyms.length < 18 &&
        m.sentence_synonyms.select{ |ss| ss.created_user_id == user.id }.count < 3
      }
    end
  end
end
