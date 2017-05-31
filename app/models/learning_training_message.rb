class LearningTrainingMessage < ActiveRecord::Base
  belongs_to :bot
  belongs_to :answer

  validates :answer_body, length: { maximum: 10000 }

  class << self
    def amp!(bot)
      amplifier = Learning::Amplifier.new(bot.user)
      arr = bot.learning_training_messages.inject([]) { |res, ltm|
        amplifier.amp(ltm.question).each do |sentence|
          _ltm = ltm.dup
          _ltm.question = sentence
          res << _ltm
        end
        res
      }
      LearningTrainingMessage.import!(arr)
    end

    # FIXME: QuestionAnswerのみ使えるようにしているが、TrainingMessageも対応する必要がある
    def amp_by_sentence_synonyms!(bot)
      arr = bot.learning_training_messages.inject([]) { |res, ltm|
        qa = bot.question_answers.find_by(question: ltm.question)
        next res if qa.blank?
        qa.sentence_synonyms.each do |ss|
          _ltm = ltm.dup
          _ltm.question = ss.body
          res << _ltm
        end
        res
      }
      LearningTrainingMessage.import!(arr)
    end
  end
end
