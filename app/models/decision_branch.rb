class DecisionBranch < ActiveRecord::Base
  belongs_to :bot
  belongs_to :answer_data, class_name: 'Answer', foreign_key: :answer_id
  belongs_to :next_answer, class_name: 'Answer', foreign_key: :next_answer_id
  belongs_to :question_answer
  has_many :child_decision_branches, class_name: 'DecisionBranch', foreign_key: :parent_decision_branch_id
end
