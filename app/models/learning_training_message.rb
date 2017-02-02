class LearningTrainingMessage < ActiveRecord::Base
  belongs_to :bot
  belongs_to :answer

  validates :answer_body, length: { maximum: 10000 }

  class << self
    def amp!(bot)
      arr = []
      amplifier = Learning::Amplifier.new(bot.user)
      bot.learning_training_messages.each do |learning_training_message|
        amplifier.amp(learning_training_message.question).each do |sentence|
          copy_model = learning_training_message.dup
          copy_model.question = sentence
          arr << copy_model
        end
      end
      LearningTrainingMessage.import!(arr)
    end

    # FIXME: QuestionAnswerのみ使えるようにしているが、TrainingMessageも対応する必要がある
    def amp_by_sentence_synonyms!(bot)
      arr = []
      bot.learning_training_messages.each do |learning_training_message|
        question_answer = bot.question_answers.find_by(question: learning_training_message.question)
        next if question_answer.blank?
        question_answer.sentence_synonyms.each do |sentence_synonym|
          copy_model = learning_training_message.dup
          copy_model.question = sentence_synonym.body
          arr << copy_model
        end
      end
      LearningTrainingMessage.import!(arr)
    end
  end
end
