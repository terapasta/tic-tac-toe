FactoryBot.define do
  factory :organization do
    name { "MyString" }
    image { "MyString" }
    description { "MyText" }
    plan { :professional }
  end
end
