FactoryGirl.define do
  factory :contact_answer do
    body "MyText"
    transition_to "MyString"
  end
end
