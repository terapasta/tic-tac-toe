class SentenceSynonym < ActiveRecord::Base
  belongs_to :question_answer
  belongs_to :created_user, class_name: 'User'

  validates :body, presence: true

  scope :target_date, -> (date) {
    if date.present?
      where('sentence_synonyms.created_at BETWEEN ? AND ?', date.beginning_of_day, date.end_of_day)
    end
  }

  scope :target_user, -> (user_id) {
    if user_id.present?
      where('sentence_synonyms.created_user_id' => user_id)
    end
  }
end
