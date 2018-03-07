class DecisionBranchSerializer < ActiveModel::Serializer
  attributes \
    :id,
    :body,
    :answer,
    :question_answer_id,
    :created_at,
    :parent_decision_branch_id,
    :child_decision_branches,
    :position

  # has_many :child_decision_branches
  has_one :answer_link
  has_many :answer_files

  def answer
    object.answer_or_answer_link_text
  end

  def child_decision_branches
    object.child_decision_branches_or_answer_link
  end
end
