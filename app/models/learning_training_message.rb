class LearningTrainingMessage < ActiveRecord::Base
  belongs_to :bot
  belongs_to :answer

  def self.to_csv(bot)
    CSV.generate do |csv|
      bot.learning_training_messages.find_each do |learning_training_message|
        base = [
          learning_training_message.question,
        ]
        recursive_put(csv, base, learning_training_message.answer)
      end
    end.encode(Encoding::SJIS)
  end

  def self.recursive_put(csv, base, answer)
    row = base.dup
    row2 = nil
    row << answer.body
    if answer.decision_branches.present?
       answer.decision_branches.each do |decision_branch|
         row2 = row.dup
         row2 << decision_branch.body
         if decision_branch.next_answer.present?
           recursive_put(csv, row2, decision_branch.next_answer)
         end
       end
    end
    csv << (row2 || row)
  end
end
