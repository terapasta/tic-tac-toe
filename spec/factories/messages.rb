FactoryGirl.define do
  factory :message do
    chat nil
    speaker :guest
    body "MyString"
  end
end
