class Answer < ActiveRecord::Base
  include ContextHoldable

  belongs_to :bot
  has_many :decision_branches
  has_one :parent_decision_branch, class_name: 'DecisionBranch', foreign_key: :next_answer_id

  accepts_nested_attributes_for :decision_branches, reject_if: :all_blank, allow_destroy: true
  # accepts_nested_attributes_for :parent_decision_branch, reject_if: :all_blank, allow_destroy: true

  # PRE_TRANSITION_CONTEXT_CONTACT_ID = [16, 49]
  # TRANSITION_CONTEXT_CONTACT_ID = 1007
  # STOP_CONTEXT_ID = 1000
  # ASK_GUEST_NAME_ID = 1001
  # ASK_EMAIL_ID = 1002
  # ASK_BODY_ID = 1003
  # ASK_COMPLETE_ID = 1004
  # ASK_ERROR_ID = 1005
  # ASK_CONFIRM_ID = 1006

  enum context: ContextHoldable::CONTEXTS
  #enum transition_to: { contact: 'contact' }

  def no_classified?
    return false if bot.nil?
    self == bot.no_classified_answer
  end
end
