class LearningTrainingMessage < ActiveRecord::Base
  belongs_to :bot
  belongs_to :answer

  validates :answer_body, length: { maximum: 10000 }

  class << self
    def amp!(bot)
      amplifier = Learning::Amplifier.new(bot.user)
      arr = bot.learning_training_messages.inject([]) { |res, ltm|
        amplifier.amp(ltm.question).each do |sentence|
          ltm.question = sentence
          res << ltm
          res
        end
      }
      LearningTrainingMessage.import!(arr, on_duplicate_key_update: [:id])
    end

    # FIXME: QuestionAnswerのみ使えるようにしているが、TrainingMessageも対応する必要がある
    def amp_by_sentence_synonyms!(bot)
      arr = bot.learning_training_messages.inject({}) { |res, ltm|
        qa = bot.question_answers.find_by(question: ltm.question)
        next if qa.blank?
        qa.sentence_synonyms.each do |ss|
          ltm.question = ss.body
          res << ltm
          res
        end
      }
      LearningTrainingMessage.import!(arr, on_duplicate_key_update: [:id])
    end
  end
end
