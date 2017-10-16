require 'rails_helper'

RSpec.describe ThreadsController, type: :controller do
  let!(:normal_user) do
    create(:user, role: :normal)
  end

  let!(:staff_user) do
    create(:user, role: :staff)
  end

  let!(:bot) do
    create(:bot, user: normal_user)
  end

  let!(:organization) do
    create(:organization, plan: :professional).tap do |org|
      org.user_memberships.create(user: normal_user)
      org.bot_ownerships.create(bot: bot)
    end
  end

  let!(:succeeded_chat) do
    create(:chat, bot: bot).tap do |chat|
      create_list(:message, 2, chat: chat)
    end
  end

  let!(:failed_chat) do
    create(:chat, bot: bot).tap do |chat|
      create_list(:message, 1, :failed, chat: chat)
      create_list(:message, 2, chat: chat)
    end
  end

  let!(:succeeded_caht_by_staff) do
    create(:chat, bot: bot, is_staff: true).tap do |chat|
      create_list(:message, 2, chat: chat)
    end
  end

  let!(:failed_chat_by_staff) do
    create(:chat, bot: bot, is_staff: true).tap do |chat|
      create_list(:message, 1, :failed, chat: chat)
      create_list(:message, 2, chat: chat)
    end
  end

  describe 'GET #index' do
    subject do
      get :index, bot_id: bot.id, answer_failed: answer_failed
      assigns[:chats]
    end

    let(:answer_failed) do
      nil
    end

    context 'when logged in as normal user' do
      before do
        sign_in normal_user
      end

      context 'without filter param' do
        it 'assigns all chats (not included is_staff)' do
          expect(subject).to match_array([succeeded_chat, failed_chat])
        end
      end

      context 'with filter param' do
        let(:answer_failed) do
          '1'
        end

        it 'assigns only failed chats (not included is_staff)' do
          expect(subject).to match_array([failed_chat])
        end
      end
    end

    context 'when logged in as staff user' do
      before do
        sign_in staff_user
      end

      context 'without filter param' do
        it 'assigns all chats (included is_staff)' do
          expect(subject).to match_array([succeeded_chat, succeeded_caht_by_staff, failed_chat, failed_chat_by_staff])
        end
      end

      context 'with filter param' do
        let(:answer_failed) do
          '1'
        end

        it 'assigns only failed chats (included is_staf)' do
          expect(subject).to match_array([failed_chat, failed_chat_by_staff])
        end
      end
    end
  end
end
