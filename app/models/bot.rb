class Bot < ActiveRecord::Base
  belongs_to :user
  has_many :chats
  has_many :trainings
  has_many :training_messages, through: :trainings
  has_many :messages, through: :chats
  has_many :learning_training_messages
  has_many :imported_training_messages
  has_many :answers
  has_many :decision_branches
  has_many :services
  has_one :score
  has_one :learning_parameter

  mount_uploader :image, ImageUploader

  before_validation :generate_token

  def has_feature?(feature)
    services.where(feature: Service.features[feature], enabled: true).present?
  end

  def learning_parameter_attributes
    if learning_parameter.present?
      learning_parameter.attributes.with_indifferent_access
    else
      { include_failed_data: false }
    end
  end

  private
    def generate_token
      self.token = SecureRandom.hex(32) if token.blank?
    end
end
