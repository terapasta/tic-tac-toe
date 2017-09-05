FactoryGirl.define do
  factory :word_mapping_synonym do
    sequence(:value) { |n| "value#{n}" }
  end
end
