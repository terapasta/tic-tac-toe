class TrainingMessage < ActiveRecord::Base
  include ContextHoldable

  belongs_to :training
  belongs_to :answer
  has_one :parent_decision_branch, through: :answer, dependent: :nullify
  enum speaker: { bot: 'bot', guest: 'guest' }
  enum context: ContextHoldable::CONTEXTS

  def parent
    training
  end

  def destroy_parent_decision_branch_relation!
    return unless self.parent_decision_branch.present?
    parent_decision_branch.next_answer_id = nil
    save!
  end
end
