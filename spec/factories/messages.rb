FactoryGirl.define do
  factory :message do
    chat nil
    speaker :guest
    body "MyString"

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
