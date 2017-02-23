class AnswerDecorator < ApplicationDecorator
  delegate_all

  def as_tree_node_json
    {
      id: answer.id,
      decisionBranches: answer.decision_branches&.decorate&.as_tree_json
    }
  end
end
