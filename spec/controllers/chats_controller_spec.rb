require 'rails_helper'

RSpec.describe ChatsController do
  let!(:bot) do
    create(:bot)
  end

  let!(:owner) do
    create(:user)
  end

  let!(:organization) do
    create(:organization, plan: :professional).tap do |org|
      org.user_memberships.create(user: owner)
      org.bot_ownerships.create(bot: bot)
    end
  end

  let!(:chat) do
    create(:chat, bot: bot, guest_key: guest_key)
  end

  let(:guest_key) do
    SecureRandom.hex(64)
  end

  describe 'GET #show' do
    before do
      sign_in owner
    end

    subject do
      cookies[:guest_key] = cookie_guest_key
      get :show, params: { token: bot.token }
    end

    context 'has guest_key' do
      let(:cookie_guest_key) do
        guest_key
      end

      it 'renders chat' do
        expect(subject).to render_template(:show)
      end
    end

    context 'has not guest_key' do
      let(:cookie_guest_key) do
        nil
      end

      it 'redirects to new' do
        expect(subject).to redirect_to("/embed/#{bot.token}/chats/new")
      end
    end
  end

  describe 'GET #new' do
    subject do
      get :new, params: { token: bot.token }
    end

    it 'creates new chat' do
      expect{ subject }.to change(Chat, :count).by(1)
    end

    it 'renders show' do
      expect(subject).to render_template(:show)
    end
  end
end
