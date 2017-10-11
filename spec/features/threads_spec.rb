require 'rails_helper'

RSpec.describe 'Threads', type: :feature, js: true do
  include RequestSpecHelper

  let!(:user) do
    create(:user)
  end

  let!(:organizations) do
    {
      lite: create(:organization, plan: :lite),
      standard: create(:organization, plan: :standard),
      professional: create(:organization, plan: :professional),
    }
  end

  let!(:bot) do
    create(:bot)
  end

  let!(:chats) do
    [
      create(:chat, bot: bot, created_at: 3.days.ago),
      create(:chat, bot: bot, created_at: 4.days.ago),
      create(:chat, bot: bot, created_at: 7.days.ago),
      create(:chat, bot: bot, created_at: 8.days.ago),
    ]
  end

  let!(:messages) do
    [
      create(:message, chat: chats[0], speaker: :bot),
      create(:message, chat: chats[0], speaker: :guest),
      create(:message, chat: chats[1], speaker: :bot),
      create(:message, chat: chats[1], speaker: :guest),
      create(:message, chat: chats[2], speaker: :bot),
      create(:message, chat: chats[2], speaker: :guest),
      create(:message, chat: chats[3], speaker: :bot),
      create(:message, chat: chats[3], speaker: :guest),
    ]
  end

  before do
    organization.bot_ownerships.create(bot: bot)
    organization.user_memberships.create(user: user)
    sign_in(user)
  end

  feature 'when joined lite plan organization' do
    let(:organization) do
      organizations[:lite]
    end

    scenario do
      visit "/bots/#{bot.id}/threads"
      expect(page).to have_content(messages[0].body)
      expect(page).to have_content(messages[1].body)
      expect(page).to_not have_content(messages[2].body)
      expect(page).to_not have_content(messages[3].body)
      expect(page).to_not have_content(messages[4].body)
      expect(page).to_not have_content(messages[5].body)
      expect(page).to_not have_content(messages[6].body)
      expect(page).to_not have_content(messages[7].body)
    end
  end

  feature 'when joined standard plan organization' do
    let(:organization) do
      organizations[:standard]
    end

    scenario do
      visit "/bots/#{bot.id}/threads"
      expect(page).to have_content(messages[0].body)
      expect(page).to have_content(messages[1].body)
      expect(page).to have_content(messages[2].body)
      expect(page).to have_content(messages[3].body)
      expect(page).to have_content(messages[4].body)
      expect(page).to have_content(messages[5].body)
      expect(page).to_not have_content(messages[6].body)
      expect(page).to_not have_content(messages[7].body)
    end
  end

  feature 'when joined professional plan organization' do
    let(:organization) do
      organizations[:professional]
    end

    scenario do
      visit "/bots/#{bot.id}/threads"
      expect(page).to have_content(messages[0].body)
      expect(page).to have_content(messages[1].body)
      expect(page).to have_content(messages[2].body)
      expect(page).to have_content(messages[3].body)
      expect(page).to have_content(messages[4].body)
      expect(page).to have_content(messages[5].body)
      expect(page).to have_content(messages[6].body)
      expect(page).to have_content(messages[7].body)
    end
  end
end
