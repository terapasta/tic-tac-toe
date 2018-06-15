require 'rails_helper'

RSpec.describe 'Tasks Spec', type: :feature, js: true do
  let!(:user) do
    create(:user)
  end

  let!(:bot) do
    create(:bot)
  end

  let!(:chat) do
    create(:chat, bot: bot)
  end

  let!(:messages) do
    create(:message, chat: chat, speaker: :guest)
    create(:message, chat: chat, speaker: :bot)
    create(:message, chat: chat, speaker: :guest)
    create(:message, chat: chat, speaker: :bot)
    create(:message, chat: chat, speaker: :guest)
    create(:message, chat: chat, speaker: :bot)
  end

  let!(:organization) do
    create(:organization).tap do |org|
      org.bot_ownerships.create(bot: bot)
      org.user_memberships.create(user: user)
    end
  end

  before do
    login_as user, scope: :user
  end

  feature 'completing multiple tasks' do
    let!(:tasks) do
      create_list(:task, 3, bot: bot)
    end

    scenario do
      visit "/bots/#{bot.id}/tasks"
      expect(page).to have_content(tasks.first.bot_message)
      expect(page).to have_content(tasks.second.bot_message)
      expect(page).to have_content(tasks.third.bot_message)
      find("input[type='checkbox'][value='#{tasks.first.id}']").click
      find("input[type='checkbox'][value='#{tasks.second.id}']").click
      sleep 1
      click_button 'まとめて対応済みにする'
      expect(page).to_not have_content(tasks.first.bot_message)
      expect(page).to_not have_content(tasks.second.bot_message)
      expect(page).to have_content(tasks.third.bot_message)
    end
  end

  feature 'チャット全体を見るボタンで画面遷移する' do
    let!(:task) do
      create(:task, bot: bot)
    end

    scenario do
      visit "/bots/#{bot.id}/tasks"
      click_link 'チャット全体を見る'
      expect(page).to have_content(bot.name)
    end 
  end
end