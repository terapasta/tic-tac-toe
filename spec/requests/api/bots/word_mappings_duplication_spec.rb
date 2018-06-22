require 'rails_helper'

RSpec.describe 'Word Mappings Duplication', type: :request do
  let!(:user) do
    create(:user)
  end

  let!(:bot) do
    create(:bot)
  end

  let!(:organization) do
    create(:organization).tap do |org|
      org.user_memberships.create(user: user)
      org.bot_ownerships.create(bot: bot)
    end
  end

  let!(:system_word_mapping) do
    create(:word_mapping, word: '日程', word_mapping_synonyms_attributes: [
      { value: 'スケジュール' }
    ])
  end

  before do
    login_as(user, scope: :user)
  end

  describe 'creating new word_mapping of own bot' do
    it 'creates new record' do
      post "/api/bots/#{bot.id}/word_mappings.json", params: {
        word_mapping: { word: '予定表' }
      }
      expect(response).to be_success

      WordMapping.last.tap do |wm|
        expect(wm.word).to eq('予定表')
        put "/api/bots/#{bot.id}/word_mappings/#{wm.id}", params: {
          word_mapping: { word_mapping_synonyms_attributes: [{ value: 'スケジュール' }] }
        }
        expect(response).to be_success
      end

      expect(WordMapping.for_bot(bot).decorate.replace_synonym(Wakatifier.apply('スケジュール教えて'))).to eq('予定 表 教え て ')
    end
  end
end