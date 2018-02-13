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
        parentQuestionAnswerId: qa_id,
        parentDecisionBranchId: db_id,
        childDecisionBranches: recursive_decision_branch_tree(db_id: db.id, all_db: all_db)
      }
    }
  end

  def make_index_json(tree, decision_branches)
    tree.reduce([]) { |acc, node|
      node_ids, _node_ids = nil, nil
      qa = object.detect{ |qa| qa.id == node[:id] }
      node_ids = ["Question-#{qa.id}"]
      acc << { text: qa.question, relatedNodeIds: node_ids }
      if qa.answer.present?
        _node_ids = node_ids + ["Answer-#{qa.id}"]
        acc << { text: qa.answer, relatedNodeIds: _node_ids }
      end
      node[:decisionBranches].each do |db_node|
        acc += recursive_make_decision_branch_indcies(db_node, (_node_ids || node_ids), decision_branches)
      end
      acc
    }
  end

  def recursive_make_decision_branch_indcies(db_node, node_ids, decision_branches)
    result = []
    _node_ids, __node_ids = nil, nil
    db = decision_branches.detect{ |db| db.id == db_node[:id] }
    _node_ids = node_ids + ["DecisionBranch-#{db.id}"]
    result << { text: db.body, relatedNodeIds: _node_ids }
    if db.answer.present?
      __node_ids = _node_ids + ["DecisionBranchAnswer-#{db.id}"]
      result << { text: db.answer, relatedNodeIds: __node_ids }
    end
    db_node[:childDecisionBranches].each do |child_db_node|
      result += recursive_make_decision_branch_indcies(child_db_node, (__node_ids || _node_ids), decision_branches)
    end
    result
  end
end
