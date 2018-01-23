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
end
