class TrainingMessage < ActiveRecord::Base
  include ContextHoldable
  include HasManySentenceSynonyms

  # acts_as_taggable_on :labels
  acts_as_taggable

  attr_accessor :other_answers

  belongs_to :training
  belongs_to :answer
  belongs_to :question_answer
  has_one :parent_decision_branch, through: :answer, dependent: :nullify
  has_one :bot, through: :training

  accepts_nested_attributes_for :answer, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :question_answer

  enum speaker: { bot: 'bot', guest: 'guest' }
  enum context: ContextHoldable::CONTEXTS

  validates :body, length: { maximum: 10000 }

  before_validation :change_answer_failed
  before_save :save_associated_message!

  def parent
    training
  end

  def destroy_parent_decision_branch_relation!
    return unless self.parent_decision_branch.present?
    parent_decision_branch.next_answer_id = nil
    save!
  end

  def previous(speaker: nil)
    training_messages = training.training_messages
    training_messages = training_messages.select{|tm| tm.id < self.id} if self.id.present?
    training_messages = training_messages.select{|tm| tm.speaker == speaker.to_s} if speaker.present?
    training_messages.sort_by{|tm| tm.id}.last
  end

  private
    def change_answer_failed
      if answer_id.present?
        self.answer_failed = false
      end
      true
    end

    def save_associated_message!
      return unless bot?
      if self.question_answer.present?
        self.question_answer.update!(answer: self.answer)
      else
        pre_training_message = previous(speaker: :guest)
        if pre_training_message.present? && self.answer.present? && self.parent_decision_branch.blank?
          question_answer = bot.question_answers.find_or_initialize_by(
            question: pre_training_message.body, answer: self.answer)
          question_answer.save!
          self.question_answer = question_answer
        end
      end
    end
end
