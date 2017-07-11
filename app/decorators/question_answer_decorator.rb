class QuestionAnswerDecorator < ApplicationDecorator
  delegate_all

  def as_tree_node_json
    {
      id: object.id,
      decisionBranches: object.decision_branches&.decorate&.as_tree_json
    }
  end
end
