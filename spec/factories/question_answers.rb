FactoryGirl.define do
  factory :question_answer do
    sequence(:question) { |n| "question_answers.question #{n}" }
    sequence(:answer) { |n| "question_answers.answer #{n}" }
  end
end
