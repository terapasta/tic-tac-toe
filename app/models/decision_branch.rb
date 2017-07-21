class DecisionBranch < ActiveRecord::Base
  belongs_to :bot
  belongs_to :question_answer
  belongs_to :answer_data, class_name: 'Answer', foreign_key: :answer_id
  belongs_to :next_answer, class_name: 'Answer', foreign_key: :next_answer_id

  has_many :child_decision_branches,
    class_name: 'DecisionBranch',
    foreign_key: :parent_decision_branch_id,
    dependent: :destroy

  # validates :question_answer_id,
  #   presence: true,
  #   if: 'parent_decision_branch_id.nil?'
  #
  # validates :parent_decision_branch_id,
  #   presence: true,
  #   if: 'question_answer_id.nil?'
end
