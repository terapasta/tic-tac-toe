FactoryGirl.define do
  factory :chatwork_decision_branch do
    sequence(:room_id) { |n| "room_id#{n}"}
    sequence(:from_account_id) { |n| "from_account_id#{n}"}
  end
end
