class QuestionAnswersDecorator < Draper::CollectionDecorator
  include QuestionAnswersCsvGeneratable

  def as_tree_json
    map(&:as_tree_node_json)
  end

  def as_repo_json
    inject({}){ |result, qa|
      result[qa.id] = qa.as_json(only: [:id, :question, :answer], include: [{ sub_questions: { only: [:id, :question] } }])
      result
    }
  end

  def classify_registered_sentence_synonyms_number
    registration_number = {}
    object.group_by_sentence_synonyms.each_value{|value|
        registration_number[value] ||= 0
        registration_number[value] += 1
     }
     return Hash[ registration_number.sort ]
  end

  def make_tree(all_decision_branches)
    object.map do |qa|
      {
        id: qa.id,
        decisionBranches: recursive_decision_branch_tree(qa_id: qa.id, all_db: all_decision_branches)
      }
    end
  end

  def recursive_decision_branch_tree(qa_id: nil, db_id: nil, all_db:)
    all_db.select{ |db|
      if qa_id.present?
        db.question_answer_id == qa_id
      elsif db_id.present?
        db.parent_decision_branch_id == db_id
      end
    }.map{ |db|
      {
        id: db.id,
        childDecisionBranches: recursive_decision_branch_tree(db_id: db.id, all_db: all_db)
      }
    }
  end
end
