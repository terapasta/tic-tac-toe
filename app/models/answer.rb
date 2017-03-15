class Answer < ActiveRecord::Base
  include ContextHoldable

  belongs_to :bot
  has_many :decision_branches, dependent: :destroy
  has_one :parent_decision_branch, class_name: 'DecisionBranch', foreign_key: :next_answer_id
  has_many :training_messages, dependent: :destroy
  has_many :question_answers

  accepts_nested_attributes_for :decision_branches, reject_if: :all_blank, allow_destroy: true
  # accepts_nested_attributes_for :parent_decision_branch, reject_if: :all_blank, allow_destroy: true

  NO_CLASSIFIED_ID = 0

  enum context: ContextHoldable::CONTEXTS
  #enum transition_to: { contact: 'contact' }

  validates :body, presence: true, length: { maximum: 65535 }
  validates :headline, length: { maximum: 100 }
  validates :bot_id, presence: true, if: :is_answer?

  scope :top_level, -> (bot_id) {
    where.not(id: DecisionBranch.select(:next_answer_id).where(bot_id: bot_id).where.not(next_answer_id: nil))
  }

  scope :search_by, -> (term) {
    if term.present?
      where('body LIKE ?', "%#{term}%")
    end
  }

  alias_attribute :value, :body

  def no_classified?
    return true if bot.nil?
    false
  end

  # STIのDefinedAnswerと識別するためのメソッド
  def is_answer?
    self.class.name == 'Answer'
  end

  def self_and_deep_child_answers
    all = [self]
    tails = [self]
    next_tails = nil
    get_next_answers = -> (answers) {
      answers.map(&:decision_branches).flatten.map(&:next_answer).flatten.compact
    }
    begin
      all += tails = next_tails || get_next_answers.call(tails)
      next_tails = get_next_answers.call(tails)
    end while next_tails.count > 0
    all
  end

  def self.find_or_null_answer(answer_id, bot, probability, classify_threshold)
    if answer_id.blank? || answer_id == NO_CLASSIFIED_ID || probability < classify_threshold
      NullAnswer.new(bot)
    else
      Answer.find(answer_id)
    end
  end
end
