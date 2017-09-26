require 'rails_helper'

RSpec.describe Learning::Amplifier do

  describe '#amp' do
    let(:bot) { create :bot }

    before do
      create(:word_mapping, word: 'カレー', word_mapping_synonyms_attributes: [{ value: 'カリー' }], bot: bot)
      create(:word_mapping, word: '食べたい', word_mapping_synonyms_attributes: [{ value: '食したい' }])
    end

    subject { Learning::Amplifier.new(bot).amp(sentence) }

    context '「カレー食べたい」という文章が渡された場合' do
      let(:sentence) { 'カレー食べたい' }
      it do
        is_expected.to eq ['カリー食べたい', 'カレー食したい']
      end
    end
  end
end
