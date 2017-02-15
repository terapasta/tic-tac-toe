FactoryGirl.define do
  factory :allowed_host do
    sequence(:domain) { |n| "*.example#{n}.com" }
  end
end
