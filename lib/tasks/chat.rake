namespace :chat do
  desc "過去メッセージに対しbotとguestのメッセージをguerst_message_idで紐付ける"
  task connect_message_from_guest_to_bot: :environment do
    begin
      ActiveRecord::Base.transaction do
        Chat.includes(:messages).find_each do |chat|
          chat.classified_pair_messages.each do |pair|
            if pair[1].present?
              pair[1].assign_attributes(guest_message_id: pair[0].id)
              pair[1].save!
            end
          end
        end
      end
    rescue => exception
      p exception.message
    end
  end
end
