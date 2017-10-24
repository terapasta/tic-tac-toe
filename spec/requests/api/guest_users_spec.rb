require 'rails_helper'

RSpec.describe '/api/guest_users', type: :request do
  let!(:guest_user) do
    create(:guest_user)
  end

  let(:response_data) do
    JSON.parse(response.body).with_indifferent_access
  end

  let(:dummy_cookies) do
    double('dummy cookies').as_null_object
  end

  before do
    allow(dummy_cookies).to receive(:encrypted) do
      { guest_key: guest_key }
    end
    allow_any_instance_of(ApplicationController).to \
      receive_message_chain(:cookies) { dummy_cookies }
  end

  describe 'GET #show' do
    let(:guest_key) do
      guest_user.guest_key
    end

    it 'returns guest_user' do
      get "/api/guest_users/#{guest_user.guest_key}"
      expect(response.status).to eq(200)
      response_data[:guestUser].tap do |gu|
        expect(gu[:id]).to eq(guest_user.id)
        expect(gu[:name]).to eq(guest_user.name)
        expect(gu[:email]).to eq(guest_user.email)
        expect(gu[:guestKey]).to eq(guest_user.guest_key)
      end
    end
  end

  describe 'POST #create' do
    let(:guest_key) do
      'hogehogehogehoge'
    end

    let(:guest_user_params) do
      {
        name: 'sample name',
        email: 'sample@example.com'
      }
    end

    subject do
      -> { post "/api/guest_users", params: { guest_user: guest_user_params } }
    end

    it 'creates guest_user' do
      expect(subject).to change(GuestUser, :count).by(1)
    end
  end

  describe 'PUT #update' do
    let(:guest_key) do
      guest_user.guest_key
    end

    let(:guest_user_params) do
      {
        name: 'updated name',
        email: 'updated@example.com'
      }
    end

    subject do
      -> { put "/api/guest_users/#{guest_key}", params: { guest_user: guest_user_params } }
    end

    it 'updates guest_user' do
      expect(subject).to change{
        guest_user.reload.to_json(only: [:name, :email])
      }.to(guest_user_params.to_json)
    end
  end

  describe 'DELETE #destroy' do
    let(:guest_key) do
      guest_user.guest_key
    end

    subject do
      -> { delete "/api/guest_users/#{guest_key}" }
    end

    it 'deletes guest_user' do
      expect(subject).to change(GuestUser, :count).by(-1)
    end
  end
end
