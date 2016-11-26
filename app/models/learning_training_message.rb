class LearningTrainingMessage < ActiveRecord::Base
  belongs_to :bot
  belongs_to :answer

  validates :answer_body, length: { maximum: 10000 }

  class << self
    def to_csv(bot)
      CSV.generate(force_quotes: true) do |csv|
        bot.learning_training_messages.find_each do |learning_training_message|
          base = [
            learning_training_message.question,
          ]
          recursive_put(csv, base, learning_training_message.answer)
        end
      end.encode(Encoding::SJIS, replace: '') # FIXME 〜などが変換時に情報落ちしてしまう
    end

    def recursive_put(csv, base, answer)
      row = base.dup
      row << answer.body
      if answer.decision_branches.present?
        answer.decision_branches.each do |decision_branch|
          row2 = row.dup
          row2 << decision_branch.body
          if decision_branch.next_answer.present?
            recursive_put(csv, row2, decision_branch.next_answer)
          else
            csv << row2
          end
        end
      else
        csv << row
      end
    end

    def amp!(bot)
      arr = []
      bot.learning_training_messages.each do |learning_training_message|
        WordMapping.variations_of(learning_training_message.question, bot.user).each do |sentence|
          copy_model = learning_training_message.dup
          copy_model.question = sentence
          arr << copy_model
        end
      end
      LearningTrainingMessage.import!(arr)
    end
  end
end
