class TopicTagging < ApplicationRecord
  belongs_to :question_answer, required: true
  belongs_to :topic_tag, required: true

  validates :question_answer, :topic_tag_id, presence: true
end
