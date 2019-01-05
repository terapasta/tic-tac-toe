require 'rails_helper'

RSpec.describe 'WsChats Password', type: :feature, js: true do
  let!(:bot) do
    create(:bot, password: password)
  end

  let(:new_chat_page) do
    "/embed/#{bot.token}/ws_chat"
  end

  let(:password) do
    'hoge'
  end

  feature 'when input correct password' do
    scenario do
      visit new_chat_page
      expect(page).to have_content('パスワードを入力してください')
      fill_in 'bot[password]', with: password
      click_button '送信'
      sleep 1
      expect(page).to have_content(bot.name)

      visit new_chat_page
      expect(page).to_not have_content('パスワードを入力してください')
      expect(page).to have_content(bot.name)
    end
  end

  feature 'when input incorrect password' do
    scenario do
      visit new_chat_page
      expect(page).to have_content('パスワードを入力してください')
      fill_in 'bot[password]', with: 'incorrect'
      click_button '送信'
      sleep 1
      expect(page).to_not have_content(bot.name)
      expect(page).to have_content('パスワードを入力してください')
    end
  end
end