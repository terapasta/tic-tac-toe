FactoryGirl.define do
  factory :bot_chatwork_credential, class: 'Bot::ChatworkCredential' do
    api_token "MyString"
    webhook_token "MyString"
  end
end
