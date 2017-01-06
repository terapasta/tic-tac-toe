class TrainingMessage < ActiveRecord::Base
  include ContextHoldable

  # acts_as_taggable_on :labels
  acts_as_taggable

  attr_accessor :other_answers

  belongs_to :training
  belongs_to :answer
  has_many :sentence_synonyms, dependent: :destroy
  has_one :parent_decision_branch, through: :answer, dependent: :nullify

  accepts_nested_attributes_for :answer, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :sentence_synonyms

  enum speaker: { bot: 'bot', guest: 'guest' }
  enum context: ContextHoldable::CONTEXTS

  validates :body, length: { maximum: 10000 }

  before_validation :change_answer_failed

  def parent
    training
  end

  def destroy_parent_decision_branch_relation!
    return unless self.parent_decision_branch.present?
    parent_decision_branch.next_answer_id = nil
    save!
  end

  def previous
    training.training_messages.where('id < ?', self.id).order("id desc").first
  end

  def self.pick_sentence_synonyms_not_enough(bot, user)
    training_messages = bot.training_messages.guest.includes(:sentence_synonyms)
    training_messages
      .select {|tm|
        tm.sentence_synonyms.length < 15 &&
        tm.sentence_synonyms.none? {|ss| ss.created_user == user}
      }.sample
  end

  private
    def change_answer_failed
      if answer_id.present?
        self.answer_failed = false
      end
      true
    end
end
