class ChatServiceUser < ApplicationRecord
  belongs_to :bot

  enum service_type: [:skype, :line, :chatwork, :slack]

  validates :uid,
    presence: true,
    uniqueness: { scope: [:bot_id, :service_type] }

  def make_guest_key
    "#{bot.id}-#{service_type}-#{uid}-#{Time.current.strftime('%Y-%m-%d')}"
  end

  def make_guest_key_if_needed!
    if guest_key == ''
      self.guest_key = make_guest_key
      save!
    end
  end
end
