require 'rails_helper'

RSpec.describe WordMapping, type: :model do
  describe 'validations' do
    context 'word does already exists as synonym' do
      let!(:other_word_mapping) do
        create(:word_mapping)
      end

      let!(:word_mapping) do
        build(:word_mapping, word: other_word_mapping.synonym)
      end

      it 'invalid' do
        expect(word_mapping.valid?).to_not be
        expect(word_mapping.errors.has_key?(:word)).to be
      end
    end
  end
end
