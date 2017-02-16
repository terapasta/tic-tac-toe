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

  let!(:allowed_hosts) do
    [
      create(:allowed_host, bot: bot, domain: '*.example.com'),
      create(:allowed_host, bot: bot, domain: 'example.com'),
    ]
  end

  let(:start_message) do
    'this is sample start message'
  end

  feature 'チャットを開始する' do
    context 'normal権限ユーザーでログインしている場合' do
      context '自分の管理ボットの場合' do
        before do
          login_as(bot_owner, scope: :user)
        end

        scenario do
          expect {
            visit "/embed/#{bot.token}/chats/new"
            expect(page).to have_content(start_message)
            expect(Chat.last.is_staff).to_not be
          }.to change(Chat, :count).by(1)
        end
      end

      context '自分の管理ボットではない場合' do
        before do
          login_as(normal_user, scope: :user)
        end

        scenario do
          expect {
            visit "/embed/#{bot.token}/chats/new"
            expect(page).to have_content('ページが表示できません')
          }.to_not change(Chat, :count)
        end
      end
    end

    context 'worker権限ユーザーでログインしている場合' do
      before do
        login_as(worker_user, scope: :user)
      end

      scenario do
        expect {
          visit "/embed/#{bot.token}/chats/new"
          expect(page).to have_content('ページが表示できません')
        }.to_not change(Chat, :count)
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
      context 'iframe経由の場合' do
        context 'リファラが許可ホストに入っている場合' do
          before do
            Capybara.current_session.driver.header('Referer', 'http://example.com')
          end

          scenario do
            expect {
              visit "/embed/#{bot.token}/chats/new"
              expect(page).to have_content(start_message)
              expect(Chat.last.is_staff).to_not be
            }.to change(Chat, :count).by(1)
          end
        end

        context 'リファラが許可ホストに入っていない場合' do
          before do
            Capybara.current_session.driver.header('Referer', 'http://hoge.com')
          end

          scenario do
            expect {
              visit "/embed/#{bot.token}/chats/new"
              expect(page).to have_content('ページが表示できません')
            }.to_not change(Chat, :count)
          end
        end
      end

      context '直接アクセスの場合' do
        scenario do
          expect {
            visit "/embed/#{bot.token}/chats/new"
            expect(page).to have_content('ページが表示できません')
          }.to_not change(Chat, :count)
        end
      end
    end
  end
end
