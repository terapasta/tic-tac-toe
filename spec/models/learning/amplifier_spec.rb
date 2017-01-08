require 'rails_helper'

RSpec.describe Learning::Amplifier do

  describe '#amp' do
    let(:user) { create :user }

    before do
      create(:word_mapping, word: 'カレー', synonym: 'カリー', user: user)
      create(:word_mapping, word: '食べたい', synonym: '食したい')
    end

    subject { Learning::Amplifier.new(user).amp(sentence) }

    context '「カレー食べたい」という文章が渡された場合' do
      let(:sentence) { 'カレー食べたい' }
      it do
        is_expected.to eq ['カリー食べたい', 'カレー食したい']
      end
    end
  end
end
