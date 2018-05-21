class QuestionAnswerSerializer < ActiveModel::Serializer
  attributes :id, :question, :answer, :zendesk_article_id
  has_many :decision_branches
  has_many :sub_questions
  has_many :answer_files
  has_many :topic_tags
end
