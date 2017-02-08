FactoryGirl.define do
  factory :question_answer do
    sequence(:question) { |n| "question_answers.question #{n}" }
    answer nil
  end
end
