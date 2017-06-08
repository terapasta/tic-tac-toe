require 'rails_helper'

RSpec.describe WordMappingsDecorator do
  let!(:word_mapping) do
    create(:word_mapping, user_id: nil, word: 'Excel', synonym: 'エクセル')
  end

  let(:decorator) do
    WordMapping.all.decorate
  end

  describe '#replace_synonym' do
    subject do
      decorator.replace_synonym('エクセルの使い方を教えて')
    end

    it '質問文の「エクセル」が「Excel」に変換されていること' do
      expect(subject).to eq('Excelの使い方を教えて')
    end
  end
end
