class AnswersDecorator < Draper::CollectionDecorator
  def as_tree_json
    map(&:as_tree_node_json)
  end

  def as_repo_json
    inject({}){ |result, decorated_answer|
      result[decorated_answer.id] = decorated_answer.as_json
      result
    }
  end
end
