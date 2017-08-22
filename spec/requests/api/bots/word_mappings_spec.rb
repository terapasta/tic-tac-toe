require 'rails_helper'

RSpec.describe 'WordMappings', type: :request do
  include RequestSpecHelper

  let!(:user) do
    create(:user)
  end

  let!(:other_user) do
    create(:user)
  end

  let!(:bot) do
    create(:bot, user: user)
  end

  let!(:other_bot) do
    create(:bot, user: other_user)
  end

  let!(:word_mapping) do
    create(:word_mapping, bot: bot)
  end

  let!(:other_word_mapping) do
    create(:word_mapping, bot: other_bot)
  end

  before do
    sign_in user
  end

  describe 'POST #create' do
    subject do
      lambda do
        post "/api/bots/#{bot_id}/word_mappings.json", params
      end
    end

    let(:params) { { word_mapping: { word: 'hoge' } } }

    context 'when own bot' do
      let(:bot_id) { bot.id }
      it { is_expected.to change(WordMapping, :count).by(1) }
    end

    context 'when others bot' do
      let(:bot_id) { other_bot.id }
      it { is_expected.to_not change(WordMapping, :count) }
    end
  end

  describe 'PUT #update' do
    subject do
      lambda do
        put "/api/bots/#{bot_id}/word_mappings/#{word_mapping_id}.json", params
      end
    end

    let(:params) { { word_mapping: { word: 'updated word' } } }

    context 'when own bot' do
      let(:bot_id) { bot.id }
      let(:word_mapping_id) { word_mapping.id }
      it { is_expected.to change{word_mapping.reload.word}.to('updated word') }
    end

    context 'when others bot' do
      let(:bot_id) { other_bot.id }
      let(:word_mapping_id) { other_word_mapping.id }
      it { is_expected.to_not change{other_word_mapping.reload.word} }
    end
  end

  describe 'DELTE #destroy' do
    subject do
      lambda do
        delete "/api/bots/#{bot_id}/word_mappings/#{word_mapping_id}.json"
      end
    end

    context 'when own bot' do
      let(:bot_id) { bot.id }
      let(:word_mapping_id) { word_mapping.id }
      it { is_expected.to change{bot.reload.word_mappings.count}.by(-1) }
    end

    context 'when others bot' do
      let(:bot_id) { other_bot.id}
      let(:word_mapping_id){ other_word_mapping.id }
      it { is_expected.to_not change{other_bot.reload.word_mappings.count} }
    end
  end
end
