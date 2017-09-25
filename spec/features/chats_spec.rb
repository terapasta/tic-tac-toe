require 'rails_helper'

RSpec.describe 'Chats', type: :features, js: true do
  include CapybaraHelpers

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
      body: has_decision_branch_question_answer.question,
      question_answer: has_decision_branch_question_answer,
    )
  end

  let!(:has_decision_branch_question_answer) do
    create(:question_answer, bot: bot).tap do |qa|
      2.times do |n|
        create(:decision_branch, question_answer: qa, bot: bot, body: "hoge#{n}")
      end
    end
  end

  let!(:decision_branches) do
    has_decision_branch_question_answer.decision_branches
  end

  let(:fake_request) do
    double(:fake_request).as_null_object.tap do |it|
      allow(it).to receive(:referer).and_return(referer)
      allow(it).to receive(:remote_ip).and_return(remote_ip)
    end
  end

  before do
    stub_const('Ml::Engine', DummyMLEngine)
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
          fill_in_input name: 'chat-message-body', value: 'サンプルメッセージ'
          expect(find("input[name='chat-message-body']").value).to_not eq('')
          within 'form' do
            click_on '質問'
          end
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

          fill_in_input name: 'chat-message-body', value: 'サンプルメッセージ'
          within 'form' do
            click_button '質問'
          end
          sleep 1
          decision_branches.first.tap do |db|
            click_link db.body
            sleep 1
            expect(page).to have_content(db.body)
            expect(page).to have_content(db.answer)
          end
        end

        scenario 'training' do
          visit "/embed/#{bot.token}/chats/new"
          fill_in_input name: 'chat-message-body', value: 'サンプルメッセージ'
          within 'form' do
            click_button '質問'
          end
          sleep 1
          expect(find("input[name='chat-message-body']").value).to eq('')
          expect(page).to have_content('サンプルメッセージ')
          expect(page).to have_content(DefinedAnswer.classify_failed_text)

          within all('.chat-section--bordered')[1] do
            find('.chat-section__switch').click
            fill_in_input name: 'chat-guest-message-body', value: 'トレーニング質問'
            fill_in_input name: 'chat-bot-message-body', value: 'トレーニング回答'
            sleep 1
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
          let(:referer) do
            'http://example.com'
          end

          let(:remote_ip) do
            '127.0.0.1'
          end

          before do
            allow_any_instance_of(ChatPolicy).to receive(:request).and_return(fake_request)
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
          let(:referer) do
            'http://hoge.com'
          end

          let(:remote_ip) do
            '127.0.0.1'
          end

          before do
            allow_any_instance_of(ChatPolicy).to receive(:request).and_return(fake_request)
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

      describe 'guest_keyの有効期限' do
        before do
          bot.allowed_hosts.delete_all
          bot.allowed_ip_addresses.delete_all
        end

        # chromedriverの時刻は変えられなかったのでpending
        xscenario do
          page_path = "/embed/#{bot.token}/chats"
          visit page_path
          fill_in_input name: 'chat-message-body', value: 'ほげほげ'
          within 'form' do
            click_on '質問'
          end
          visit page_path
          page.save_screenshot
          expect(page).to have_content('ほげほげ')
          pp Time.now
          Delorean.time_travel_to('44 days after') do
            pp Time.now
            visit page_path
            page.save_screenshot
            expect(page).to have_content('ほげほげ')
          end
          pp Time.now
          Delorean.time_travel_to('46 days after') do
            pp Time.now
            visit page_path
            page.save_screenshot
            expect(page).to_not have_content('ほげほげ')
          end
        end
      end
    end
  end
end
