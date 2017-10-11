FactoryGirl.define do
  factory :message do
    chat nil
    speaker :guest
    sequence(:body) { |n| "messages.body #{n}" } 

    trait :failed do
      speaker :bot
      answer_failed true
    end

    trait :failed_by_user do
      speaker :bot
      answer_failed true
      answer_failed_by_user true
    end
  end
end
