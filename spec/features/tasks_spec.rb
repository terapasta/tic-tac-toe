require 'rails_helper'

RSpec.describe 'Tasks Spec', type: :feature, js: true do
  let!(:user) do
    create(:user)
  end

  let!(:bot) do
    create(:bot)
  end

  let!(:organization) do
    create(:organization).tap do |org|
      org.bot_ownerships.create(bot: bot)
      org.user_memberships.create(user: user)
    end
  end

  let!(:tasks) do
    create_list(:task, 3, bot: bot)
  end

  before do
    login_as user, scope: :user
  end

  feature 'completing multiple tasks' do
    scenario do
      visit "/bots/#{bot.id}/tasks"
      expect(page).to have_content(tasks.first.bot_message)
      expect(page).to have_content(tasks.second.guest_message)
      expect(page).to have_content(tasks.third.guest_message)
      find("input[type='checkbox'][value='#{tasks.first.id}']").click
      find("input[type='checkbox'][value='#{tasks.second.id}']").click
      sleep 1
      click_button 'まとめて対応済みにする'
      expect(page).to_not have_content(tasks.first.bot_message)
      expect(page).to_not have_content(tasks.second.guest_message)
      expect(page).to have_content(tasks.third.guest_message)
    end
  end
end