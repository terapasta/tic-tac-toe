FactoryGirl.define do
  factory :bot_line_credential, class: 'Bot::LineCredential' do
    sequence(:channel_id) { |n| "0123456789#{n}" }
    sequence(:channel_secret) { |n| "channel_secret#{n}" }
    sequence(:channel_access_token) { |n| "channel_access_token#{n}" }
  end
end
