class DecisionBranch < ApplicationRecord
  belongs_to :bot
  belongs_to :question_answer

  # 自分からリンクする
  has_one :answer_link
  has_one :dest_question_answer,
    through: :answer_link,
    source: :answer_record,
    source_type: 'QuestionAnswer'
  has_one :dest_decision_branch,
    through: :answer_link,
    source: :answer_record,
    source_type: 'DecisionBranch'

  # 他のdecision_branchからの被リンク
  has_many :answer_links, as: :answer

  has_many :child_decision_branches,
    -> { order(position: :asc) },
    class_name: 'DecisionBranch',
    foreign_key: :parent_decision_branch_id,
    dependent: :destroy

  belongs_to :parent_decision_branch,
    class_name: 'DecisionBranch',
    foreign_key: :parent_decision_branch_id

  has_many :answer_files,
    dependent: :destroy

  accepts_nested_attributes_for :child_decision_branches

  acts_as_list scope: [:question_answer_id, :parent_decision_branch_id]

  def answer_or_answer_link_text
    if answer_link.present?
      (dest_question_answer || dest_decision_branch)&.answer
    else
      answer
    end
  end

  def child_decision_branches_or_answer_link
    if answer_link.present?
      dest_question_answer&.decision_branches.presence ||
      dest_decision_branch&.child_decision_branches ||
      []
    else
      child_decision_branches
    end
  end
end
