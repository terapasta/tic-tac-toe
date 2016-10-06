class Bot < ActiveRecord::Base
  belongs_to :user
  has_many :chats
  has_many :trainings
  has_many :answers
  has_many :decision_branches
  has_many :services
  belongs_to :start_answer, class_name: 'Answer', foreign_key: :start_answer_id
  belongs_to :no_classified_answer, class_name: 'Answer', foreign_key: :no_classified_answer_id

  mount_uploader :image, ImageUploader

  def has_feature?(feature)
    services.where(feature: Service.features[feature], enabled: true).present?
  end

  def embed_code
    "<iframe width=\"560\" height=\"315\" src=\"https://www.youtube.com/embed/#{token}\" frameborder=\"0\" allowfullscreen></iframe>"
  end
end
