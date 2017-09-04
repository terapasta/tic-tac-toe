require 'rails_helper'

RSpec.describe WordMapping, type: :model do
  describe 'validations' do
    context 'word does already exists as synonym' do      
      let(:word_mapping) do
        build(:word_mapping, word: 'ほげ')
      end
      
      context 'word_mapping_validatorを用いる場合' do
        it 'invalidになること' do
          params = {
            word: 'ほげ',
            word_mapping_synonyms_attributes: [
              {
                value: 'ほげ',
              }
            ]
          }
          @word_mapping = WordMapping.new(params)
          expect(@word_mapping).to_not be_valid
          expect(@word_mapping.errors[:base]).to be_present
        end
        
        it 'invalidになること' do
          params = {
            word: 'ほげ',
            word_mapping_synonyms_attributes: [
              {
                value: 'hoge',
              },
              {
                value: 'hoge',
              }
            ]
          }
          @word_mapping = WordMapping.new(params)
          expect(@word_mapping).to_not be_valid
          expect(@word_mapping.errors[:base]).to be_present
        end
        
        it 'invalidになること' do
          word_mapping = create(:word_mapping)
          synonym = create(:word_mapping_synonym, word_mapping_id: word_mapping.id)
          
          params = {
            word: synonym.value,
          }
          @word_mapping = WordMapping.new(params)
          expect(@word_mapping).to_not be_valid
          expect(@word_mapping.errors[:base]).to be_present
        end
      end
    end
  end
end
