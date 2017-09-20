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

  def create_by(guest_key, &block)
    build(guest_key: guest_key).tap do |chat|
      block.call(chat) if block_given?
      chat.build_start_message
      chat.save!
    end
  end

  def today_count_of_guests
    not_staff(true).not_normal(true).in_today.count
  end
end
