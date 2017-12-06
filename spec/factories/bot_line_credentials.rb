FactoryGirl.define do
  factory :bot_line_credential, class: 'Bot::LineCredential' do
    channel_id "MyString"
    channel_secret "MyString"
    channel_access_token "MyString"
  end
end
