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

    # botをnilで呼び出す場合があるのでtryを使っています
    def picking_sentence_synonyms(bot, user)
      messages = begin
        if self == TrainingMessage
          (bot.try(:training_messages) || TrainingMessage)
            .guest.includes(:sentence_synonyms)
        elsif self == ImportedTrainingMessage
          (bot.try(:imported_training_messages) || ImportedTrainingMessage)
            .includes(:sentence_synonyms)
        end
      end
      messages.select {|m|
        m.sentence_synonyms.length < 18 &&
        m.sentence_synonyms.select{ |ss| ss.created_user_id == user.id }.count < 3
      }
    end
  end

  def registered_sentence_synonyms_count_by(user)
    @_registered_sentence_synonyms_counts ||= {}
    @_registered_sentence_synonyms_counts[user] ||=
      sentence_synonyms.where(created_user_id: user.id).count
  end

  def build_sentence_synonyms_for(user, options = { max_count: 3 })
    count = registered_sentence_synonyms_count_by(user)
    (options[:max_count] - count).times.map{ sentence_synonyms.build }
  end
end
