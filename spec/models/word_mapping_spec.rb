require 'rails_helper'

RSpec.describe WordMapping, type: :model do
  let!(:user) { create :user }

  describe '.variations_of' do
    before do
      create(:word_mapping, word: '社長', synonym: '代表取締役', user: user)
      create(:word_mapping, word: '社長', synonym: 'CEO')
    end

    subject { WordMapping.variations_of(sentence, user) }

    context '「社長！一杯どうですか？」という文章が渡された場合' do
      let(:sentence) { '社長！一杯どうですか？' }
      it do
        is_expected.to eq ['代表取締役！一杯どうですか？', 'CEO！一杯どうですか？']
      end
    end

    context '「CEO！一杯どうですか？」という文章が渡された場合' do
      let(:sentence) { 'CEO！一杯どうですか？' }
      it do
        is_expected.to eq ['社長！一杯どうですか？']
      end
    end
  end
end
