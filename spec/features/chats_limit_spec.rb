require 'rails_helper'

RSpec.describe 'Chats limit', type: :feature do
  include RequestSpecHelper

  let!(:user) do
    create(:user)
  end

  let!(:bot) do
    create(:bot)
  end

  let!(:organizations) do
    {
      lite: create(:organization, plan: :lite),
      standard: create(:organization, plan: :standard),
      professional: create(:organization, plan: :professional)
    }
  end

  let(:new_chat_page) do
    "/embed/#{bot.token}/chats/new"
  end

  let(:now) do
    Time.current
  end

  before do
    organization.bot_ownerships.create(bot: bot)
    organization.user_memberships.create(user: user)
  end

  def make_conversation_on(chat)
    3.times do
      create(:message, chat: chat, speaker: :guest, created_at: now)
      create(:message, chat: chat, speaker: :bot, created_at: now)
    end
  end

  feature 'when joined lite plan organization' do
    let(:organization) do
      organizations[:lite]
    end

    scenario 'cannot starts chat more than 30' do
      # empty message chat
      visit new_chat_page
      30.times do |n|
        # not empty message chat
        visit new_chat_page
        expect(page.status_code).to eq(200)
        make_conversation_on Chat.last
      end
      expect(bot.chats.today_count_of_guests).to eq(30)

      visit new_chat_page
      expect(page.status_code).to eq(429)
    end
  end

  feature 'when joined standard plan organization' do
    let(:organization) do
      organizations[:standard]
    end

    scenario 'cannot starts chat more than 60' do
      # empty message chat
      visit new_chat_page
      60.times do |n|
        # not empty message chat
        visit new_chat_page
        expect(page.status_code).to eq(200)
        make_conversation_on Chat.last
      end
      expect(bot.chats.today_count_of_guests).to eq(60)

      visit new_chat_page
      expect(page.status_code).to eq(429)
    end
  end

  feature 'when joined professional plan organization' do
    let(:organization) do
      organizations[:professional]
    end

    scenario 'there is no limit' do
      # empty message chat
      visit new_chat_page
      70.times do |n|
        # not empty message chat
        visit new_chat_page
        expect(page.status_code).to eq(200)
        make_conversation_on Chat.last
      end
      expect(bot.chats.today_count_of_guests).to eq(70)

      visit new_chat_page
      expect(page.status_code).to eq(200)
    end
  end
end
