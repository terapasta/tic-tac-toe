class DecisionBranch < ActiveRecord::Base
  belongs_to :bot
  belongs_to :answer
  belongs_to :next_answer, class_name: 'Answer', foreign_key: :next_answer_id
end
