module MessagesHelper
  def message_has_decision_branches?(msg)
    msg.question_answer&.decision_branches&.any? || msg.decision_branch&.child_decision_branches&.any?
  end

  def message_get_decision_branches_from(msg)
    msg.question_answer&.decision_branches || msg.decision_branch.child_decision_branches
  end
end