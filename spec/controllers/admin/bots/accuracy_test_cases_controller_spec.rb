require 'rails_helper'

RSpec.describe Admin::Bots::AccuracyTestCasesController, type: :controller do
  let!(:bot) do
    create(:bot, user: user)
  end

  let!(:user) do
    create(:user)
  end

  let!(:staff) do
    create(:user, :staff)
  end

  let!(:accuracy_test_cases) do
    create_list(:accuracy_test_case, 3, bot: bot)
  end

  describe 'GET #index' do
    subject do
      get :index, bot_id: bot.id
    end

    context 'when logged in as normal' do
      before do
        sign_in user
      end

      it 'raises error' do
        expect{subject}.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context 'when logged in as staff' do
      before do
        sign_in staff
      end

      it 'show all accuracy_test_cases' do
        expect(response).to be_success
        expect(assigns[:accuracy_test_cases]).to match_array(accuracy_test_cases)
      end
    end
  end

  describe 'POST #create' do
    context 'when sends valid params' do
      it 'creates a new record' do
      end
    end

    context 'when sends invalid params' do
      it 'not creates a new record' do
      end
    end
  end

  describe 'GET #edit' do
    it 'shows edit form' do
    end
  end

  describe 'PUT #edit' do
    context 'when sends valid params' do
      it 'updates a record' do
      end
    end

    context 'when sends invalid params' do
      it 'not updates a record' do
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes a record' do
    end
  end
end
