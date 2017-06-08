FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@test.com" }
    password 'hogehoge'
    role :normal

    trait :staff do
      role :staff
    end
  end
end
