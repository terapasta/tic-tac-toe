module HasManySentenceSynonyms
  extend ActiveSupport::Concern

  included do
    has_many :sentence_synonyms,
      foreign_key: :training_message_id,
      dependent: :destroy
    accepts_nested_attributes_for :sentence_synonyms

    before_update :deassociate_sentence_synonyms_if_needed
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
        elsif self == QuestionAnswer
          (bot.try(:question_answers) || QuestionAnswer)
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

  def deassociate_sentence_synonyms_if_needed
    target_attr = case self
    when QuestionAnswer
      :question
    when TrainingMessage
      :body
    end
    if send("#{target_attr}_changed?")
      sentence_synonyms.each do |ss|
        ss.training_message_id = nil
      end
    end
  end
end
