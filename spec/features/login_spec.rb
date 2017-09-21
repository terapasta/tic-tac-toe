require 'rails_helper'

RSpec.describe 'Login', typre: :feature, js: true do
  include CapybaraHelpers

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
      fill_in_input name: 'user[email]', value: user.email
      fill_in_input name: 'user[password]', value: 'hogehoge'
      click_on 'ログイン'
      expect(page).to have_content(bot.name)
    end
  end

  feature 'login and select bot' do
    scenario do
      visit '/users/sign_in'
      expect(page).to have_content('ログイン')
      fill_in_input name: 'user[email]', value: user.email
      fill_in_input name: 'user[password]', value: 'hogehoge'
      click_on 'ログイン'
      click_on bot.name

      expect(page).to have_content('チャットする')
      expect(page).to have_content('Q&A')
    end
  end
end
