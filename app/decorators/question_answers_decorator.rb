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

  def count_and_grouping_sentence_synonyms
    count_sentence_synonyms_registration_number_of(object.grouping_sentence_synonyms)
  end

  def count_sentence_synonyms_registration_number_of(grouping_sentence_synonyms)
    registration_number = {}

    grouping_sentence_synonyms.each_value{|value|
      case value
      when value
        if registration_number[value].nil?
          registration_number[value] =+ 1
        else
          registration_number[value] += 1
        end
      end
     }
     return registration_number
  end
end
