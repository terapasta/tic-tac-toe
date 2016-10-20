class Bot < ActiveRecord::Base
  belongs_to :user
  has_many :chats
  has_many :trainings
  has_many :learning_training_messages
  has_many :imported_training_messages
  has_many :answers
  has_many :decision_branches
  has_many :services
  has_one :score

  mount_uploader :image, ImageUploader

  def has_feature?(feature)
    services.where(feature: Service.features[feature], enabled: true).present?
  end
end
