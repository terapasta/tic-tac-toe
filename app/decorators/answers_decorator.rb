class AnswersDecorator < Draper::CollectionDecorator
  def as_json_for_tree_component
    object.map{ |a| create_answer_json_node(a) }
  end

  private
    def create_answer_json_node(answer)
      return nil if answer.nil?
      {
        id: answer.id,
        headline: answer.headline,
        body: answer.body,
        decisionBranches: answer.decision_branches.map{ |db|
          create_decision_branch_json_node(db)
        }
      }
    end

    def create_decision_branch_json_node(decision_branch)
      {
        id: decision_branch.id,
        body: decision_branch.body,
        answer: create_answer_json_node(decision_branch.next_answer)
      }
    end
end
