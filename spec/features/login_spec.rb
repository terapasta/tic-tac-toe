require 'rails_helper'

RSpec.describe 'Login', typre: :feature, js: true do
  let!(:user) do
    create(:user)
  end

  let!(:bot) do
    create(:bot, user: user)
  end

  let!(:bot2) do
    create(:bot, user: user)
  end

  feature 'login' do
    scenario do
      visit '/users/sign_in'
      expect(page).to have_content('ログイン')
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: 'hogehoge'
      click_on 'ログイン'
      page.save_screenshot
      expect(page).to have_content(bot.name)
    end
  end

  feature 'login and select bot' do
    scenario do
      visit '/users/sign_in'
      expect(page).to have_content('ログイン')
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: 'hogehoge'
      click_on 'ログイン'
      page.save_screenshot
      within "#bot-#{bot.id}" do
        click_on '詳細'
      end

      expect(page).to have_content('チャットする')
      expect(page).to have_content('Q&A管理')
    end
  end
end
