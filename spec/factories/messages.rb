FactoryGirl.define do
  factory :message do
    chat nil
    speaker :guest
    body "MyString"

    trait :failed do
      answer_failed true
    end
  end
end
