FactoryGirl.define do
  factory :sub_question do
    sequence(:question) { |n| "sub_question.question #{n}" }
  end
end
