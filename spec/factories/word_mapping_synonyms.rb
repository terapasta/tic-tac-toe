FactoryGirl.define do
  factory :word_mapping_synonym do
    sequence(:value) { |n| "word_mapping_synonyms.value #{n}" }
  end
end
