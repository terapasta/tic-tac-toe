class DecisionBranchDecorator < ApplicationDecorator
  delegate_all

  def as_tree_node_json
    {
      id: decision_branch.id,
      answer: decision_branch.next_answer&.decorate&.as_tree_node_json
    }
  end
end
