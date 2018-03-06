class Bot < ApplicationRecord
  include Bot::HasSuggestsMessage

  DefaultWidgetSubtitle = 'AIチャットボットがご対応します'

  belongs_to :user, required: false
  has_many :chats, -> { extending HasManyChatsExtension }
  has_many :messages, through: :chats
  has_many :learning_training_messages
  has_many :question_answers
  has_many :topic_tags
  has_many :decision_branches
  has_one :score, dependent: :destroy
  has_one :learning_parameter, dependent: :destroy
  has_many :sentence_synonyms, through: :question_answers
  has_many :allowed_hosts, dependent: :destroy
  has_many :word_mappings, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :accuracy_test_cases, dependent: :destroy
  has_many :exports, dependent: :destroy
  has_many :allowed_ip_addresses, dependent: :destroy
  has_many :organization_ownerships, class_name: 'Organization::BotOwnership'
  has_many :organizations, through: :organization_ownerships
  has_many :organization_memberships, class_name: 'Organization::UserMembership', through: :organizations, source: :user_memberships
  has_many :organization_users, class_name: 'User', through: :organization_memberships, source: :user
  has_one :tutorial
  has_many :chat_service_users
  has_one :line_credential
  has_one :chatwork_credential
  has_one :microsoft_credential

  accepts_nested_attributes_for :allowed_hosts, allow_destroy: true
  accepts_nested_attributes_for :allowed_ip_addresses, allow_destroy: true
  accepts_nested_attributes_for :topic_tags, allow_destroy: true
  accepts_nested_attributes_for :tutorial

  serialize :selected_question_answer_ids, Array
  serialize :chat_test_results, Array

  enum learning_status: { processing: 'processing', failed: 'failed', successed: 'successed' }

  scope :demos, -> { where(is_demo: true) }

  mount_uploader :image, ImageUploader

  before_validation :set_token_if_needed, :set_learning_status_changed_at_if_needed

  def learning_parameter_attributes
    if learning_parameter.present?
      attrs = learning_parameter.attributes.with_indifferent_access
    else
      attrs = LearningParameter.default_attributes
    end
    # TODO フィールドが変わる度に修正が必要になってしまう
    attrs.slice(:algorithm, :feedback_algorithm).symbolize_keys
  end

  def use_similarity_classification?
    if learning_parameter.present?
      return learning_parameter.use_similarity_classification?
    end
    true
  end

  def reset_training_data!
    transaction do
      self.selected_question_answer_ids = []
      question_answers.destroy_all
      learning_training_messages.destroy_all
      chats.destroy_all
      ActiveRecord::Base.connection.execute("DELETE FROM dumps WHERE bot_id = #{id}")
    end
  end

  def classify_failed_message_with_fallback
    classify_failed_message.presence || DefinedAnswer.classify_failed_text
  end

  def add_selected_question_answer_ids(question_answer_id)
    self.selected_question_answer_ids.push(question_answer_id)
  end

  def remove_selected_question_answer_ids(question_answer_id)
    self.selected_question_answer_ids.delete(question_answer_id)
  end

  def selected_question_answers
    question_answers.where(id: selected_question_answer_ids)
  end

  def learn_later
    my_queue = DelayedJob.all.order(created_at: :asc).to_a.select{ |q|
      q.job_class == LearnJob && q.arguments == [self.id]
    }
    if my_queue.count.zero? ||
       my_queue.all?{ |q| q.locked_at.present? }
      LearnJob.perform_later(self.id)
    end
  end

  def chats_limit_per_day
    organizations&.first&.chats_limit_per_day || Organization::ChatsLimitPerDay[:professional]
  end

  def change_token_and_set_demo_finished_time!
    self.update!(token: generate_token, demo_finished_at: Time.current)
  end

  private
    def set_token_if_needed
      self.token = generate_token if token.blank?
    end

    def generate_token
      SecureRandom.hex(32)
    end

    def set_learning_status_changed_at_if_needed
      if learning_status_changed?
        self.learning_status_changed_at = Time.current
      end
    end
end
