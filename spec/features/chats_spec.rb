require 'rails_helper'

RSpec.describe 'Chats', type: :features do
  let!(:normal_user) do
    create(:user)
  end

  let!(:worker_user) do
    create(:user, role: :worker)
  end

  let!(:staff_user) do
    create(:user, role: :staff)
  end

  let!(:bot_owner) do
    create(:user, role: :normal)
  end

  let!(:bot) do
    create(:bot, user: bot_owner, start_message: start_message)
  end

  let(:start_message) do
    'this is sample start message'
  end

  feature 'チャットを開始する' do
    context 'normal権限ユーザーでログインしている場合' do
      before do
        login_as(normal_user, scope: :user)
      end

      scenario do
        expect {
          visit "/embed/#{bot.token}/chats/new"
          expect(page).to have_content(start_message)
          expect(Chat.last.is_staff).to_not be
        }.to change(Chat, :count).by(1)
      end
    end

    context 'worker権限ユーザーでログインしている場合' do
      before do
        login_as(worker_user, scope: :user)
      end

      scenario do
        expect {
          visit "/embed/#{bot.token}/chats/new"
          expect(page).to have_content(start_message)
          expect(Chat.last.is_staff).to_not be
        }.to change(Chat, :count).by(1)
      end
    end

    context 'staff権限ユーザーでログインしている場合' do
      before do
        login_as(staff_user, scope: :user)
      end

      scenario do
        expect {
          visit "/embed/#{bot.token}/chats/new"
          expect(page).to have_content(start_message)
          expect(Chat.last.is_staff).to be
        }.to change(Chat, :count).by(1)
      end
    end

    context 'ログインしていない場合' do
      scenario do
        expect {
          visit "/embed/#{bot.token}/chats/new"
          expect(page).to have_content(start_message)
          expect(Chat.last.is_staff).to_not be
        }.to change(Chat, :count).by(1)
      end
    end
  end
end
