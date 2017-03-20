class QuestionAnswersDecorator < Draper::CollectionDecorator
  include QuestionAnswersCsvGeneratable

  def as_tree_json
    map(&:as_tree_node_json)
  end

  def as_repo_json
    inject({}){ |result, qa|
      result[qa.id] = qa
      result
    }
  end
end
