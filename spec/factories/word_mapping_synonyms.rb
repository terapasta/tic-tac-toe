FactoryGirl.define do
  factory :word_mapping_synonym do
    sequence(:value) { |n| "synonyms.value #{n}" }
  end
end
