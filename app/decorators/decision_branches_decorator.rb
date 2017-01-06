class DecisionBranchesDecorator < Draper::CollectionDecorator
  def as_repo_json
    inject({}){ |result, decorated_decision_branch|
      result[decorated_decision_branch.id] = decorated_decision_branch.as_json
      result
    }
  end
end