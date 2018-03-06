class User < ApplicationRecord
  include OrganizationMembershipable

  # Include default devise modules. Others available are:
  #  :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         # :confirmable,

  enum role: { normal: 0, worker: 1, staff: 2 }

  has_many :sentence_synonyms, foreign_key: :created_user_id

  validates :role, presence: true

  def email_notification
    !!(notification_settings || {})['email']
  end

  def email_notification=(val)
    self.notification_settings ||= {}
    self.notification_settings['email'] = val.to_bool
  end

  def change_password!
    new_password = generate_password
    self.update!(password: new_password, password_confirmation: new_password)
  end

  private
    def generate_password
      SecureRandom.hex(10)
    end
end
