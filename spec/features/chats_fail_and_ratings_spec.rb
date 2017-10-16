require 'rails_helper'

RSpec.describe 'Chats Failed and Ratings', type: :feature, js: true do
  include CapybaraHelpers

  let!(:bot) do
    create(:bot)
  end

  let!(:users) do
    create_list(:user, 2)
  end

  let!(:organization) do
    create(:organization).tap do |org|
      users.each{ |user| org.user_memberships.create(user: user) }
      org.bot_ownerships.create(bot: bot)
    end
  end

  before do
    stub_const('Ml::Engine', DummyMLEngine)
  end

  feature 'failed and bad rating' do
    scenario do
      visit "/embed/#{bot.token}/chats/new"
      fill_in_input name: 'chat-message-body', value: 'サンプルメッセージ'
      click_on '質問'
      sleep 1

      find('.chat-message__rating-button.good').click
      sleep 1
      ActionMailer::Base.deliveries.last.tap do |email|
        expect(email.subject).to include('回答に失敗しました')
        expect(email.to).to match_array(users.map(&:email))
      end

      Task.last.tap do |task|
        expect(task.guest_message).to eq('サンプルメッセージ')
        expect(task.bot_message).to be_blank
      end

      find('.chat-message__rating-button.bad').click
      sleep 1
      ActionMailer::Base.deliveries.last.tap do |email|
        expect(email.subject).to include('回答によくない評価がつきました')
        expect(email.to).to match_array(users.map(&:email))
      end

      Task.last.tap do |task|
        expect(task.guest_message).to eq('サンプルメッセージ')
        expect(task.bot_message).to_not be_blank
      end
    end
  end
end
