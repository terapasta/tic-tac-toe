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

  describe '.replace_synonym_all!' do
    let!(:bot) do
      create(:bot)
    end

    let!(:question_answers) do
      %w(ところで拉麺を食すのはどうですか ところでピアーノを奏でるのはどうですか).map do |q|
        create(:question_answer, bot_id: bot.id, question: q)
      end
    end

    let!(:system_word_mapping) do
      create(:word_mapping, bot_id: nil, word: 'ラーメンを食べる').tap do |wm|
        wm.word_mapping_synonyms.create(value: '拉麺を食す')
      end
    end

    let!(:bot_word_mapping) do
      create(:word_mapping, bot_id: bot.id, word: 'ピアノを弾く').tap do |wm|
        wm.word_mapping_synonyms.create(value: 'ピアーノを奏でる')
      end
    end

    subject do
      WordMapping.replace_synonym_all!(bot.id)
    end

    it 'replace synonyms by use bot word mappings' do
      subject
      expect(question_answers[0].reload.question_wakati).to eq('ところで ラーメン を 食べる の は どう です か ')
      expect(question_answers[1].reload.question_wakati).to eq('ところで ピアノ を 弾く の は どう です か ')
    end
  end
end
