class AnswerLink < ApplicationRecord
  belongs_to :decision_branch

  belongs_to :answer_record,
    polymorphic: true

  validates :decision_branch_id,
    uniqueness: { scope: [:answer_record_id, :answer_record_type] }
end
