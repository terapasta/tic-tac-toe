FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@test.com" }
    password 'hogehoge'
    role :normal
    sequence(:confirmation_token) { |n| "hogehoge#{n}" }
    notification_settings nil

    trait :staff do
      role :staff
    end
  end
end
