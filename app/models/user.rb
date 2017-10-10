class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  #  :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         # :confirmable,

  has_many :bots
  has_many :sentence_synonyms, foreign_key: :created_user_id
  has_many :organization_memberships, class_name: 'Organization::UserMembership'
  has_many :organizations, through: :organization_memberships

  enum role: { normal: 0, worker: 1, staff: 2 }
  enum plan: { lite: 0, standard: 1, professional: 2 }

  HistoriesLimitDays = {
    lite: 3,
    standard: 7,
    professional: Float::INFINITY,
  }.with_indifferent_access.freeze

  def histories_limit_days
    HistoriesLimitDays[plan]
  end

  def histories_limit_time
    histories_limit_days.days.ago.beginning_of_day
  end

  def ec_plan?
    lite? || standard?
  end

  ChatsLimitPerDay = {
    lite: 30,
    standard: 60,
    professional: Float::INFINITY,
  }.with_indifferent_access.freeze

  def chats_limit_per_day
    ChatsLimitPerDay[plan]
  end
end
