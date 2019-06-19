require 'rails_helper'

RSpec.describe 'JWT', type: :request do
  let!(:user) do
    create(:user)
  end

  describe 'GET /api/jwt' do
    context 'when user isnt logged in' do
      it 'returns 403 error' do
        get '/api/jwt'
        expect(response.status).to eq(401)
        expect(JSON.parse(response.body)['error']).to be_present
      end
    end

    context 'when user is logged in' do
      before do
        login_as(user, scope: :user)
      end

      it 'returns jwt' do
        get '/api/jwt'
        token = JSON.parse(response.body)['token']
        expect(token).to be_present
      end
    end
  end
end