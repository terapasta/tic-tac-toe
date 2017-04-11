FactoryGirl.define do
  factory :service do
    feature 1
    enabled false
  end

  trait :enable_suggest_question do
    feature :suggest_question
    enabled true
  end
end
