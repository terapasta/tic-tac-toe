class QuestionAnswerPolicy < ApplicationPolicy
  def permitted_attributes
    [
      :id,
      {
        sentence_synonyms_attributes: [
          :body,
          :created_user_id
        ]
      }
    ]
  end
end
