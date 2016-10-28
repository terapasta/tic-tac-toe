class TrainingMessage < ActiveRecord::Base
  include ContextHoldable

  attr_accessor :other_answers

  belongs_to :training
  belongs_to :answer
  has_one :parent_decision_branch, through: :answer, dependent: :nullify

  accepts_nested_attributes_for :answer, reject_if: :all_blank, allow_destroy: true

  enum speaker: { bot: 'bot', guest: 'guest' }
  enum context: ContextHoldable::CONTEXTS

  validates :body, length: { maximum: 10000 }

  def parent
    training
  end

  def destroy_parent_decision_branch_relation!
    return unless self.parent_decision_branch.present?
    parent_decision_branch.next_answer_id = nil
    save!
  end
end
