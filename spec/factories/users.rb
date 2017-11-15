FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@test.com" }
    password 'hogehoge'
    role :normal
    sequence(:confirmation_token) { |n| "hogehoge#{n}" }
    email_notification true

    trait :staff do
      role :staff
    end
  end
end
