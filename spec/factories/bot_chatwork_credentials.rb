FactoryGirl.define do
  factory :bot_chatwork_credential, class: 'Bot::ChatworkCredential' do
    api_token "MyString"
    bot_id 1
  end
end
