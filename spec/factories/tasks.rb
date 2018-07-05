FactoryGirl.define do
  factory :task do
    sequence(:guest_message) { |n| "tasks.guest_message #{n}" }
    sequence(:bot_message) { |n| "tasks.bot_messags #{n}" }
    is_done false
    sequence(:guest_message_id) { |n| n }
    sequence(:bot_message_id) { |n| n + 1 }
  end
end