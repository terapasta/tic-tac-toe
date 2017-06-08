FactoryGirl.define do
  factory :topic_tag do
    sequence(:name) { |n| "topic_tags.name #{n}" }
  end
end
