class AnswersDecorator < Draper::CollectionDecorator
  def as_tree_json
    object.map{ |a| create_answer_json_node(a) }
  end

  def as_repo_json
    inject({}){ |result, decorated_answer|
      result[decorated_answer.id] = decorated_answer.as_json
      result
    }
  end

  private
    def create_answer_json_node(answer)
      return nil if answer.nil?
      {
        id: answer.id,
        decisionBranches: answer.decision_branches.map{ |db|
          create_decision_branch_json_node(db)
        }
      }
    end

    def create_decision_branch_json_node(decision_branch)
      {
        id: decision_branch.id,
        answer: create_answer_json_node(decision_branch.next_answer)
      }
    end
end
