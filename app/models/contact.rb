class Contact < ActiveRecord::Base
  include Virtus.model
  include ActiveModel::Model

  attribute :email,       String
  attribute :subject,     String
  attribute :description, String

  validates :email,       presence: true
  validates :subject,     presence: true
  validates :description, presence: true
end
