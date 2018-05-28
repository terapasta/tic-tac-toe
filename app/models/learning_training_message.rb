class LearningTrainingMessage < ApplicationRecord
  belongs_to :bot

  validates :answer_body, length: { maximum: 10000 }

  scope :by_results, -> (results) {
    results
      .map{ |it| it.slice(:question_answer_id, :question).to_h }
      .map{ |it| where(it) }
      .reduce(:or)
  }

  class << self
    def amp!(bot)
      amplifier = Learning::Amplifier.new(bot)
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
