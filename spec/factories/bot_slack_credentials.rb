FactoryGirl.define do
  factory :bot_slack_credential, class: 'Bot::SlackCredential' do
    team_id "MyString"
    bot nil
  end
end
