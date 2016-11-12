FactoryGirl.define do
  factory :answer do
    bot
    context 'normal'
    body "MyText"
  end
end
