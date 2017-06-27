FactoryGirl.define do
  factory :task do
    guest_message "MyText"
    bot_message "MyText"
    is_done false
    bot_id 1
  end
end
