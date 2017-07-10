require 'rails_helper'

# HACK: csv_importer_specに統一したい
RSpec.describe QuestionAnswer do
  describe '.import_csv' do
    let!(:bot) do
      create(:bot)
    end

    def csv(file_prefix)
      Rails.root.join("spec/fixtures/#{file_prefix}_question_answers.csv").open
    end

    let(:file_prefix) do # default
      'sjis_valid'
    end

    subject(:importing) do
      -> { QuestionAnswer.import_csv(csv(file_prefix), bot) }
    end

    subject(:updated_valid_importing) do
      -> { QuestionAnswer.import_csv(csv('sjis_valid-2'), bot) }
    end

    context 'when invalid csv' do
      let(:file_prefix) do
        'sjis_invalid'
      end

      it 'returns a CsvImporter instance that has status and failed row number' do
        result = importing.call
        expect(result).to be_an_instance_of(QuestionAnswer::CsvImporter)
        expect(result.succeeded).to_not be
        expect(result.current_row).to eq(2)
      end

      it 'not creates QuestionAnswer record' do
        expect{importing.call}.to_not change(QuestionAnswer, :count)
      end

      it 'not creates Answer record' do
        expect{importing.call}.to_not change(Answer, :count)
      end
    end

    context 'when valid csv' do
      it 'retuns CsvImporter instance' do
        result = importing.call
        expect(result).to be_an_instance_of(QuestionAnswer::CsvImporter)
        expect(result.succeeded).to be
      end

      it 'creates QuestionAnswer record' do
        expect{importing.call}.to change(QuestionAnswer, :count).by(2)
      end

      it 'creates Answer record' do
        expect{importing.call}.to change(Answer, :count).by(4)
      end
    end

    context 'when multiple times with valid csv' do
      before do
        importing.call
      end

      it 'not creates duplicated QuestionAnswer records' do
        expect{importing.call}.to_not change(QuestionAnswer, :count)
      end

      it 'not creates duplicated Answer records' do
        expect{importing.call}.to_not change(Answer, :count)
      end
    end

    context 'when only updated answer csv' do
      before do
        importing.call
      end

      it 'not creates duplicated QuestionAnswer records' do
        expect{updated_valid_importing.call}.to_not change(QuestionAnswer, :count)
      end

      it 'not creates new Answer records' do
        expect{updated_valid_importing.call}.to change { Answer.order(:updated_at).last.body }.to('アンサー1更新済み')
        expect{updated_valid_importing.call}.to change(Answer, :count).by(0)
      end
    end
  end
end
