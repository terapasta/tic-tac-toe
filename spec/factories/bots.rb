FactoryBot.define do
  factory :bot do
    user_id { nil }
    sequence(:name) { |n| "bots.name #{n}" }
    is_demo { false }
  end
end
