require 'rails_helper'

RSpec.describe 'GuestUser', type: :feature, js: true do
  include RequestSpecHelper
  include CapybaraHelpers

  let!(:user) do
    create(:user, :staff)
  end

  let!(:bot) do
    create(:bot, user: user, enable_guest_user_registration: flag)
  end

  let(:name) do
    'samplename'
  end

  let(:email) do
    'sample@example.com'
  end

  before do
    stub_const('Ml::Engine', DummyMLEngine)
  end

  feature 'register guest_user' do
    let(:flag) do
      true
    end

    scenario do
      visit "/embed/#{bot.token}/chats/new"
      sleep 1
      fill_in_input id: 'guest-user-name', value: name
      fill_in_input id: 'guest-user-email', value: email
      find('#guest-user-submit').click
      expect(page).to have_content('ユーザー情報を保存しました')

      fill_in_input name: 'chat-message-body', value: 'サンプルメッセージ'
      click_on '質問'

      sign_in user
      sign_in user
      sign_in user
      visit "/bots/#{bot.id}/threads"
      click_on 'これ以前の発言もすべて見る'

      expect(page).to have_content(name)
      expect(page).to have_content(email)
    end
  end

  feature 'not register guest_user' do
    let(:flag) do
      false
    end

    scenario do
      visit "/embed/#{bot.token}/chats/new"
      expect(page).to_not have_content('ユーザー情報')
    end
  end
end
