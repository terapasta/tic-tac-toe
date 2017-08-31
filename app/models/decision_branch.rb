class DecisionBranch < ActiveRecord::Base
  belongs_to :bot
  belongs_to :question_answer

  has_many :child_decision_branches,
    class_name: 'DecisionBranch',
    foreign_key: :parent_decision_branch_id,
    dependent: :destroy

  accepts_nested_attributes_for :child_decision_branches
end
