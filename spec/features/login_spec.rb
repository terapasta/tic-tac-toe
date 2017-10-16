require 'rails_helper'

RSpec.describe 'Login', typre: :feature, js: true do
  include CapybaraHelpers

  let!(:user) do
    create(:user)
  end

  let!(:bot) do
    create(:bot)
  end

  let!(:bot2) do
    create(:bot)
  end

  let!(:organization) do
    create(:organization, plan: :professional).tap do |org|
      org.user_memberships.create(user: user)
      org.bot_ownerships.create(bot: bot)
    end
  end

  feature 'login' do
    scenario do
      visit '/users/sign_in'
      expect(page).to have_content('ログイン')
      fill_in_input name: 'user[email]', value: user.email
      fill_in_input name: 'user[password]', value: 'hogehoge'
      click_on 'ログイン'
      expect(page).to_not have_content('Bot一覧')
      expect(page).to have_content(bot.name)
    end
  end

  feature 'login and select bot' do
    before do
      organization.bot_ownerships.create(bot: bot2)
    end

    scenario do
      visit '/users/sign_in'
      expect(page).to have_content('ログイン')
      fill_in_input name: 'user[email]', value: user.email
      fill_in_input name: 'user[password]', value: 'hogehoge'
      click_on 'ログイン'
      expect(page).to have_content('Bot一覧')
      click_on bot.name

      expect(page).to have_content('チャットする')
      expect(page).to have_content('Q&A')
    end
  end
end
