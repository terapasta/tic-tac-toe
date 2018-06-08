require 'rails_helper'

RSpec.describe 'Threads', type: :feature, js: true do
  include RequestSpecHelper
  include CapybaraHelpers

  let!(:normal_user) do
    create(:user, role: :normal)
  end

  let!(:staff_user) do
    create(:user, role: :staff)
  end

  let!(:bot) do
    create(:bot)
  end

  let!(:organization) do
    create(:organization).tap do |org|
      org.user_memberships.create(user: normal_user)
      org.bot_ownerships.create(bot: bot)
    end
  end

  let!(:chats) do
    [
      create(:chat, bot: bot, is_staff: false, is_normal: false, created_at: 1.days.ago),   # guest_chat
      create(:chat, bot: bot, is_staff: true, is_normal: false, created_at: 2.days.ago),    # staff_chat
      create(:chat, bot: bot, is_staff: false, is_normal: true, created_at: 3.days.ago)     # normal_chat
    ]
  end

  let!(:messages) do
    list = []
    create(:message, chat: chats[0], speaker: 'guest').tap do |m| # 0 guest
      list << m
      list << create(:message, chat: chats[0], speaker: 'bot', guest_message_id: m.id)   # 1
    end
    create(:message, chat: chats[1], speaker: 'guest').tap do |m| # 2 staff
      list << m
      list << create(:message, chat: chats[1], speaker: 'bot', guest_message_id: m.id)  # 3
    end
    create(:message, chat: chats[0], speaker: 'guest').tap do |m| # 4 staff
      list << m
      list << create(:message, chat: chats[0], speaker: 'bot', answer_failed: true, guest_message_id: m.id)  # 5
    end
    create(:message, chat: chats[0], speaker: 'guest').tap do |m| # 6 guest
      list << m
      list << create(:message, chat: chats[0], speaker: 'bot', guest_message_id: m.id)   # 7
    end
    create(:message, chat: chats[0], speaker: 'guest').tap do |m| # 8 guest
      list << m
      list << create(:message, chat: chats[0], speaker: 'bot', guest_message_id: m.id)   # 9
    end
    create(:message, chat: chats[0], speaker: 'guest').tap do |m| # 10 guest
      list << m
      list << create(:message, chat: chats[0], speaker: 'bot', answer_marked: true, guest_message_id: m.id)   # 11
    end
    create(:message, chat: chats[2], speaker: 'guest').tap do |m| # 12 normal
      list << m
      list << create(:message, chat: chats[2], speaker: 'bot', guest_message_id: m.id)  # 13
    end
    list
  end

  let!(:ratings) do
    [
      # create(:rating, bot_id: bot.id, level: :good, message_id: messages[7].id, question: messages[6].body, answer: messages[7].body),
      # create(:rating, bot_id: bot.id, level: :bad, message_id: messages[9].id, question: messages[8].body, answer: messages[9].body)
      messages[7].good!,
      messages[9].bad!
    ]
  end

  feature 'not staff user dont show staff messages' do
    before do
      sign_in(normal_user)
    end

    scenario do
      visit "/bots/#{bot.id}/threads"
      #page.save_screenshot
      expect(page).to have_content(messages[0].body)
      expect(page).to have_content(messages[1].body)
      expect(page).to_not have_content(messages[2].body)
      expect(page).to_not have_content(messages[3].body)
      expect(page).to have_content(messages[4].body)
      expect(page).to have_content(messages[5].body)
      expect(page).to have_content(messages[6].body)
      expect(page).to have_content(messages[7].body)
      expect(page).to have_content(messages[8].body)
      expect(page).to have_content(messages[9].body)
      expect(page).to have_content(messages[10].body)
      expect(page).to have_content(messages[11].body)
      expect(page).to_not have_content(messages[12].body)
      expect(page).to_not have_content(messages[13].body)
    end

    scenario do
      visit '/bots/#{bot.id}/threads?answer_failed=false&bad=false&good=false&marked=false&normal=1'
      expect(page).to_not have_content(messages[2].body)
      expect(page).to_not have_content(messages[3].body)
    end
  end

  feature 'has params of answer_failed or good or bad or marked' do
    before do
      sign_in(normal_user)
    end

    scenario do
      visit '/bots/#{bot.id}/threads?answer_failed=true&good=false&bad=false&marked=false'
      expect(page).to_not have_content(messages[6].body)
      expect(page).to_not have_content(messages[7].body)
      expect(page).to_not have_content(messages[8].body)
      expect(page).to_not have_content(messages[9].body)
      expect(page).to_not have_content(messages[10].body)
      expect(page).to_not have_content(messages[11].body)
    end

    scenario do
      visit '/bots/#{bot.id}/threads?answer_failed=false&good=true&bad=false&marked=false'
      if messages[7].good!
        expect(page).to_not have_content(messages[4].body)
        expect(page).to_not have_content(messages[5].body)
        expect(page).to_not have_content(messages[8].body)
        expect(page).to_not have_content(messages[9].body)
        expect(page).to_not have_content(messages[10].body)
        expect(page).to_not have_content(messages[11].body)
      end
    end

    scenario do
      visit '/bots/#{bot.id}/threads?answer_failed=false&good=false&bad=true&marked=false'
      if messages[9].bad!
        expect(page).to_not have_content(messages[4].body)
        expect(page).to_not have_content(messages[5].body)
        expect(page).to_not have_content(messages[6].body)
        expect(page).to_not have_content(messages[7].body)
        expect(page).to_not have_content(messages[10].body)
        expect(page).to_not have_content(messages[11].body)
      end
    end

    scenario do
      visit '/bots/#{bot.id}/threads?answer_failed=false&good=false&bad=false&marked=true'
      expect(page).to_not have_content(messages[4].body)
      expect(page).to_not have_content(messages[5].body)
      expect(page).to_not have_content(messages[6].body)
      expect(page).to_not have_content(messages[7].body)
      expect(page).to_not have_content(messages[8].body)
      expect(page).to_not have_content(messages[9].body)
    end
  end

end
