module HasManyChatsExtension
  def find_last_by!(guest_key)
    where(guest_key: guest_key).last.tap do |chat|
      if chat.nil?
        fail ActiveRecord::RecordNotFound.new("Cannot find last chat by guest_key(#{guest_key})")
      end
    end
  end

  def find_last_by(guest_key)
    find_last_by!(guest_key)
  rescue => e
    nil
  end
end
