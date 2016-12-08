FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "sample-#{n}@example.com" }
    password "samplepass"
  end
end
