FactoryGirl.define do
  factory :answer do
    bot
    sequence(:body) { |n| "answers.body #{n}" } 
  end
end
