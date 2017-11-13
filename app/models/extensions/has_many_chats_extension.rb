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

  def create_by(attributes, &block)
    build(attributes).tap do |chat|
      block.call(chat) if block_given?
      chat.build_start_message
      chat.save!
    end
  end

  def today_count_of_guests
    count_of_guests_in(Time.current)
  end

  def count_of_guests_in(date)
    not_staff(true).not_normal(true).in_date_by_unique_user(date).count
  end
end
