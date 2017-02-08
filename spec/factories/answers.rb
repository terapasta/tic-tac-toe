FactoryGirl.define do
  factory :answer do
    bot
    context 'normal'
    sequence(:body) { |n| "answers.body #{n}" } 
  end
end
