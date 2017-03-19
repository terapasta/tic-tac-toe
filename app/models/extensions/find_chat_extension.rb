module FindChatExtension
  def find_last_by!(guest_key)
    where(guest_key: guest_key).last.tap do |chat|
      if chat.nil?
        fail ActiveRecord::RecordNotFound.new("Cannot find last chat by guest_key(#{guest_key})")
      end
    end
  end
end
