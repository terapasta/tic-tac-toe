require 'rails_helper'

RSpec.describe ChatsController do
  let!(:bot) do
    create(:bot, user: owner)
  end

  let!(:owner) do
    create(:user)
  end

  let!(:chat) do
    create(:chat, bot: bot, guest_key: guest_key)
  end

  let(:guest_key) do
    'sample guest key'
  end

  describe 'GET #show' do
    before do
      sign_in owner
    end

    subject do
      cookies[:guest_key] = cookie_guest_key
      get :show, { token: bot.token }
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
        expect(subject).to redirect_to(new_chats_path)
      end
    end
  end

  describe 'GET #new' do
    subject do
      get :new, { token: bot.token }
    end

    it 'creates new chat' do
      expect{ subject }.to change(Chat, :count).by(1)
    end

    it 'renders show' do
      expect(subject).to render_template(:show)
    end
  end
end
