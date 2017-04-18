require 'rails_helper'

RSpec.describe Learning::Converter do
  describe '#unify_words' do
    let(:bot) { create(:bot) }
    let(:converter)  { Learning::Converter.new(bot) }
    subject { converter.unify_words }

    it { is_expected.to eq converter }

    context '同義語が登録されている場合' do
      let!(:word_mapping) { create(:word_mapping, user_id: nil, word: 'Excel', synonym: 'エクセル') }
      let!(:learning_training_message) { create(:learning_training_message, bot: bot, question: 'エクセルの使い方を教えて') }

      it '質問文の「エクセル」が「Excel」に変換されていること' do
        m = bot.learning_training_messages.first
        subject
        expect(m.question).to eq 'Excelの使い方を教えて'
      end
    end
  end

  describe '#save' do
    # TODO
  end
end
