class Bot < ActiveRecord::Base
  belongs_to :user
  has_many :chats
  has_many :trainings
  has_many :training_messages, through: :trainings
  has_many :messages, through: :chats
  has_many :learning_training_messages
  has_many :question_answers
  has_many :answers
  has_many :decision_branches
  has_many :services
  has_one :score
  has_one :learning_parameter
  has_many :sentence_synonyms, through: :question_answers
  has_many :allowed_hosts

  enum learning_status: { processing: 'processing', failed: 'failed', successed: 'successed' }

  mount_uploader :image, ImageUploader

  before_validation :generate_token

  def has_feature?(feature)
    services.where(feature: Service.features[feature], enabled: true).present?
  end

  def learning_parameter_attributes
    if learning_parameter.present?
      attrs = learning_parameter.attributes.with_indifferent_access
    else
      attrs = LearningParameter.default_attributes
    end
    attrs.slice(:algorithm, :params_for_algorithm, :include_failed_data, :include_tag_vector, :classify_threshold)
  end

  def reset_training_data!
    transaction do
      trainings.destroy_all
      question_answers.destroy_all
      learning_training_messages.destroy_all
      chats.destroy_all
      answers.destroy_all

      model_files = Rails.root.join('learning', 'learning', 'models', Rails.env, "#{id}_*")
      FileUtils.rm(Dir.glob(model_files))
    end
  end

  private
    def generate_token
      self.token = SecureRandom.hex(32) if token.blank?
    end
end
