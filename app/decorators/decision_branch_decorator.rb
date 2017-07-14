class DecisionBranchDecorator < ApplicationDecorator
  delegate_all

  def as_tree_node_json
    {
      id: object.id,
      childDecisionBranches: object.child_decision_branches&.decorate&.as_tree_json
    }
  end
end
