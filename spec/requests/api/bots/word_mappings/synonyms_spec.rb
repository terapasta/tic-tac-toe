require 'rails_helper'

RSpec.describe 'WordMappingSynonyms', type: :request do
  include RequestSpecHelper

  let!(:user) do
    create(:user)
  end

  let!(:bot) do
    create(:bot, user: user)
  end

  let!(:other_user) do
    create(:user)
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

  let!(:synonym) do
    create(:word_mapping_synonym, word_mapping: word_mapping)
  end

  let!(:other_synonym) do
    create(:word_mapping_synonym, word_mapping: other_word_mapping)
  end

  before do
    sign_in user
  end

  describe 'POST #create' do
    subject do
      lambda do
        post "/api/bots/#{bot_id}/word_mappings/#{word_mapping_id}/synonyms.json", params
      end
    end

    let(:params) { { word_mapping_synonym: { value: 'hoge' } } }

    context 'when own bot' do
      let(:bot_id) { bot.id }
      let(:word_mapping_id) { word_mapping.id }
      it { is_expected.to change{word_mapping.reload.word_mapping_synonyms.count}.by(1) }
    end

    context 'when others bot' do
      let(:bot_id) { other_bot.id }
      let(:word_mapping_id) { other_word_mapping.id }
      it { is_expected.to_not change{other_word_mapping.reload.word_mapping_synonyms.count} }
    end
  end

  describe 'PUT #update' do
    subject do
      lambda do
        put "/api/bots/#{bot_id}/word_mappings/#{word_mapping_id}/synonyms/#{synonym_id}.json", params
      end
    end

    let(:params) { { word_mapping_synonym: { value: 'updated value' } } }

    context 'when own bot' do
      let(:bot_id) { bot.id }
      let(:word_mapping_id) { word_mapping.id }
      let(:synonym_id) { synonym.id }
      it { is_expected.to change{synonym.reload.value}.to('updated value') }
    end

    context 'when others bot' do
      let(:bot_id) { other_bot.id }
      let(:word_mapping_id) { other_word_mapping.id }
      let(:synonym_id) { other_synonym.id }
      it { is_expected.to_not change{other_synonym.reload.value} }
    end
  end

  describe 'DELETE #destroy' do
    subject do
      lambda do
        delete "/api/bots/#{bot.id}/word_mappings/#{word_mapping.id}/synonyms/#{synonym.id}.json"
      end
    end

    context 'when own bot' do
      let(:bot_id) { bot.id }
      let(:word_mapping_id) { word_mapping.id }
      let(:synonym_id) { synonym.id }
      it { is_expected.to change{word_mapping.reload.word_mapping_synonyms.count}.by(-1) }
    end

    context 'when others bot' do
      let(:bot_id) { other_bot.id }
      let(:word_mapping_id) { other_word_mapping.id }
      let(:synonym_id) { other_synonym.id }
      it { is_expected.to_not change{other_word_mapping.reload.word_mapping_synonyms.count} }
    end
  end
end
