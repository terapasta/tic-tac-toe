FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@test.com" }
    password 'hogehoge'
    role :normal
    confirmation_token 'hogehoge'

    trait :staff do
      role :staff
    end
  end
end
