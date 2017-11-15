require 'rails_helper'

RSpec.describe 'My Pages', type: :feature do
  let!(:user) do
    create(:user)
  end

  before do
    visit '/users/sign_in'
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: 'hogehoge'
    click_on 'ログイン'
  end

  feature 'access root' do
    scenario do
      visit '/my'
      expect(page).to have_content('現在のパスワード')
    end
  end

  feature 'email' do
    scenario do
      visit '/my/email/edit'
      fill_in 'user[email]', with: 'hoge@example.com'
      click_on '更新'
      expect(page).to have_content('メールアドレスを更新しました')
      expect(user.reload.email).to eq('hoge@example.com')
    end
  end

  feature 'password' do
    scenario do
      visit '/my/password/edit'
      fill_in 'user[current_password]', with: 'hogehoge'
      fill_in 'user[password]', with: 'newpassword'
      fill_in 'user[password_confirmation]', with: 'newpassword'
      click_on '更新'
      expect(page).to have_content('パスワードを更新しました')
      expect(user.reload.valid_password?('newpassword')).to be
    end
  end

  feature 'notification' do
    scenario do
      expect{
        visit '/my/notification/edit'
        check 'user[email_notification]'
        click_on '更新'
        expect(page).to have_content('通知を更新しました')
        user.reload
    }.to change(user, :email_notification).to(true)
    end
  end
end