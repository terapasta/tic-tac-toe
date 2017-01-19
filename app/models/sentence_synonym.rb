class SentenceSynonym < ActiveRecord::Base
  belongs_to :training_message
  belongs_to :created_user, class_name: 'User'

  validates :body, presence: true

  scope :target_date, -> (date) {
    if date.present?
      where('sentence_synonyms.created_at BETWEEN ? AND ?', date.beginning_of_day, date.end_of_day)
    end
  }
end
