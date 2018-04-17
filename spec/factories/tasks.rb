FactoryGirl.define do
  factory :task do
    sequence(:guest_message) { |n| "tasks.guest_message #{n}" }
    sequence(:bot_message) { |n| "tasks.bot_messags #{n}" }
    is_done false
  end
end
