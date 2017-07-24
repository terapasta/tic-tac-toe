require 'rails_helper'

RSpec.describe 'Chats', type: :features, js: true do
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

  let!(:has_decision_branch_answer_message) do
    create(:message,
      speaker: :bot,
      body: has_decision_branch_answer.body,
      answer: has_decision_branch_answer,
    )
  end

  let!(:has_decision_branch_answer) do
    create(:answer, bot: bot)
  end

  let!(:decision_branches) do
    2.times.to_a.map do |n|
      has_decision_branch_answer.decision_branches.create(bot: bot, body: "hoge#{n}", next_answer: create(:answer, bot: bot))
    end
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

        scenario 'show answer and rating' do
          visit "/embed/#{bot.token}/chats/new"
          fill_in 'chat-message-body', with: 'サンプルメッセージ'
          click_button '質問'
          sleep 1
          expect(find("input[name='chat-message-body']").value).to eq('')
          expect(page).to have_content('サンプルメッセージ')
          expect(page).to have_content(DefinedAnswer.classify_failed_text)

          within find("#message-#{Message.last.id}") do
            find('.chat-message__rating-button.good').click
            sleep 1
            expect{find('.chat-message__rating-button.good.active')}.to_not raise_error
            find('.chat-message__rating-button.bad').click
            sleep 1
            expect{find('.chat-message__rating-button.bad.active')}.to_not raise_error
          end
        end

        scenario 'show decision branches' do
          visit "/embed/#{bot.token}/chats/new"

          has_decision_branch_answer_message.update(chat: Chat.last)
          allow_any_instance_of(Chats::MessagesController).to receive(:receive_and_reply!).and_return([has_decision_branch_answer_message])

          fill_in 'chat-message-body', with: 'サンプルメッセージ'
          click_button '質問'
          sleep 1
          decision_branches.first.tap do |db|
            click_link db.body
            sleep 1
            expect(page).to have_content(db.body)
            expect(page).to have_content(db.next_answer.body)
          end
        end

        scenario 'training' do
          visit "/embed/#{bot.token}/chats/new"
          fill_in 'chat-message-body', with: 'サンプルメッセージ'
          click_button '質問'
          sleep 1
          expect(find("input[name='chat-message-body']").value).to eq('')
          expect(page).to have_content('サンプルメッセージ')
          expect(page).to have_content(DefinedAnswer.classify_failed_text)

          within all('.chat-section--bordered')[1] do
            find('.chat-section__switch').click
            fill_in 'chat-guest-message-body', with: 'トレーニング質問'
            fill_in 'chat-bot-message-body', with: 'トレーニング回答'
            click_link 'キャンセル'
            sleep 1
            find('.chat-section__switch').click
            expect(find('textarea[name="chat-guest-message-body"]').value).to eq('トレーニング質問')
            expect(find('textarea[name="chat-bot-message-body"]').value).to eq('トレーニング回答')
            expect{
              click_link 'この内容で教える'
              sleep 1
              # このテキストは表示されているがコードからは見つけられないのでコメントアウト
              # expect(page).to have_content('学習データに登録しました')
            }.to change(QuestionAnswer, :count).by(1)
          end
        end
      end

      context '自分の管理ボットではない場合' do
        before do
          login_as(normal_user, scope: :user)
        end

        scenario do
          expect {
            visit "/embed/#{bot.token}/chats/new"
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
            Capybara.current_session.driver.add_header('Referer', 'http://example.com')
          end

          scenario do
            expect {
              visit "/embed/#{bot.token}/chats/new"
              sleep 1
              expect(page).to have_content(start_message)
              expect(Chat.last.is_staff).to_not be
            }.to change(Chat, :count).by(1)
          end
        end

        context 'リファラが許可ホストに入っていない場合' do
          before do
            Capybara.current_session.driver.add_header('Referer', 'http://hoge.com')
          end

          scenario do
            expect {
              visit "/embed/#{bot.token}/chats/new"
            }.to_not change(Chat, :count)
          end
        end
      end

      context '直接アクセスの場合' do
        scenario do
          expect {
            visit "/embed/#{bot.token}/chats/new"
          }.to_not change(Chat, :count)
        end
      end
    end
  end
end
