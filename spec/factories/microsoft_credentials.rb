FactoryGirl.define do
  factory :bot_microsoft_credential, class: 'Bot::MicrosoftCredential' do
    app_id 'app_id'
    app_password 'app_password'
  end
end
