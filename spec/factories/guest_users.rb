FactoryGirl.define do
  factory :guest_user do
    sequence(:name) { |n| "guest_user.name #{n}" }
    sequence(:email) { |n| "sample-#{n}@example.com" }
    sequence(:guest_key) { |n| "guest_user-guest_key-#{n}" } 
  end
end
