require 'rails_helper'

RSpec.describe WordMappingsDecorator do
  let!(:bot) do
    create(:bot)
  end

  let!(:system_word_mapping) do
    create(:word_mapping, word: '日程').tap do |wm|
      wm.update(word_mapping_synonyms_attributes: [
        { value: 'スケジュール' }
      ])
    end
  end

  let!(:bot_word_mapping) do
    create(:word_mapping, bot: bot, word: '予定表').tap do |wm|
      wm.update(word_mapping_synonyms_attributes: [
        { value: 'スケジュール' }
      ])
    end
  end

  let(:decorator) do
    WordMapping.for_bot(bot).decorate
  end

  describe '#replace_synonym' do
    subject do
      decorator.replace_synonym('スケジュールを教えて')
    end

    it '質問文の「スケジュール」が「予定表」に変換されていること' do
      expect(subject).to eq('予定表を教えて')
    end
  end
end
