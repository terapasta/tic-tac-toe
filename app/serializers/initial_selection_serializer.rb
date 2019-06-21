class InitialSelectionSerializer < ActiveModel::Serializer
  include DeepCamelizeKeys

  attributes :id, :question_answer_id, :question_answer, :position

  def question_answer
    deep_camelize_keys(object.question_answer.as_json(only: [:id, :question]))
  end
end