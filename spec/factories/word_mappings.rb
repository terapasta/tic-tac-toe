FactoryGirl.define do
  factory :word_mapping do
    sequence(:word) { |n| "word#{n}" }
    sequence(:synonym) { |n| "synonym#{n}" }
  end
end
