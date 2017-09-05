FactoryGirl.define do
  factory :word_mapping do
    sequence(:word) { |n| "word#{n}" }
  end
end
