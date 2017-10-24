class User < ApplicationRecord
  include OrganizationMembershipable

  # Include default devise modules. Others available are:
  #  :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         # :confirmable,

  enum role: { normal: 0, worker: 1, staff: 2 }

  has_many :sentence_synonyms, foreign_key: :created_user_id
end
