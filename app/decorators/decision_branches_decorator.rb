class DecisionBranchesDecorator < Draper::CollectionDecorator
  def as_repo_json
    inject({}){ |result, decorated_decision_branch|
      result[decorated_decision_branch.id] = decorated_decision_branch.as_json
      result
    }
  end

  def as_tree_json
    map(&:as_tree_node_json)
  end
end
