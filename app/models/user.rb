class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  #  :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         # :confirmable,

  has_many :bots
  has_many :sentence_synonyms, foreign_key: :created_user_id

  enum role: { normal: 0, worker: 1, staff: 2 }
  enum plan: { lite: 0, standard: 1, professional: 2 }

  def ec_plan?
    lite? || standard?
  end
end
