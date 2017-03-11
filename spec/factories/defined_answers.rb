FactoryGirl.define do
  factory :defined_answer do
    bot
    context 'normal'
    sequence(:body) { |n| "answers.body #{n}" }
  end
end
