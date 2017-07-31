class Bot < ActiveRecord::Base
  belongs_to :user
  has_many :chats, -> { extending HasManyChatsExtension }
  has_many :messages, through: :chats
  has_many :learning_training_messages
  has_many :question_answers
  has_many :topic_tags
  has_many :answers
  has_many :decision_branches
  has_many :services, dependent: :destroy
  has_one :score, dependent: :destroy
  has_one :learning_parameter, dependent: :destroy
  has_many :sentence_synonyms, through: :question_answers
  has_many :allowed_hosts, dependent: :destroy
  has_many :word_mappings, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :accuracy_test_cases, dependent: :destroy
  has_many :exports, dependent: :destroy
  has_many :allowed_ip_addresses, dependent: :destroy

  accepts_nested_attributes_for :allowed_hosts, allow_destroy: true

  serialize :selected_question_answer_ids, Array

  enum learning_status: { processing: 'processing', failed: 'failed', successed: 'successed' }

  mount_uploader :image, ImageUploader

  before_validation :generate_token, :set_learning_status_changed_at_if_needed

  def has_feature?(feature)
    services.where(feature: Service.features[feature], enabled: true).present?
  end

  def learning_parameter_attributes
    if learning_parameter.present?
      attrs = learning_parameter.attributes.with_indifferent_access
    else
      attrs = LearningParameter.default_attributes
    end
    # TODO フィールドが変わる度に修正が必要になってしまう
    attrs.slice(:algorithm, :params_for_algorithm, :include_failed_data, :include_tag_vector, :classify_threshold, :use_similarity_classification)
  end

  def reset_training_data!
    transaction do
      trainings.destroy_all
      question_answers.destroy_all
      learning_training_messages.destroy_all
      chats.destroy_all
      answers.destroy_all

      model_dir = Rails.root.join('learning', 'learning', 'models', Rails.env, "#{id}")
      FileUtils.rm_r(model_dir)
    end
  end

  def classify_failed_message_with_fallback
    classify_failed_message.presence || DefinedAnswer.classify_failed&.body || ""
  end

  def add_selected_question_answer_ids(question_answer_id)
    self.selected_question_answer_ids.push(question_answer_id).tap do
    end
  end

  def remove_selected_question_answer_ids(question_answer_id)
    self.selected_question_answer_ids.delete(question_answer_id).tap do
    end
  end

  def selected_question_answers
    question_answers.where(id: selected_question_answer_ids)
  end

  private
    def generate_token
      self.token = SecureRandom.hex(32) if token.blank?
    end

    def set_learning_status_changed_at_if_needed
      if learning_status_changed?
        self.learning_status_changed_at = Time.current
      end
    end
end
