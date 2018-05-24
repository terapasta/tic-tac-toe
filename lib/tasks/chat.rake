namespace :chat do
  desc "過去メッセージに対しbotとguestのメッセージをguerst_message_idで紐付ける"
  task connected_message_from_guest_to_bot: :environment do
    begin
      ActiveRecord::Base.transaction do
        Chat.all.each do |chat|
          chat.classified_pair_messages.each do |pair|
            if pair[1].present?
              pair[1].update_attributes(guest_message_id: pair[0].id)
            end
          end
        end
      end
    rescue => e
      p e.message      
    end
  end
end
