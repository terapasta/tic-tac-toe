FactoryGirl.define do
  factory :organization_bot_ownership, class: 'Organization::BotOwnership' do
    organization_id 1
    bot_id 1
  end
end
