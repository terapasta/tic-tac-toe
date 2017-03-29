class TopicTagging < ActiveRecord::Base
  belongs_to :question_answer, required: true
  belongs_to :topic_tag, required: true

  validates :question_answers_id, :topic_tags_id, presence: true
end
