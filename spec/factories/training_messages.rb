FactoryGirl.define do
  factory :training_message do
    training
    speaker :guest
    body 'こんにちは、元気ですか'
  end
end
