require 'rails_helper'

RSpec.describe ImportedTrainingMessage do
  describe '.import_csv' do
    let!(:bot) do
      create(:bot)
    end

    def csv(file_prefix)
      Rails.root.join("spec/fixtures/#{file_prefix}_imported_training_messages.csv").open
    end

    let(:file_prefix) do # default
      'valid'
    end

    subject(:importing) do
      -> { ImportedTrainingMessage.import_csv(csv(file_prefix), bot) }
    end

    subject(:updated_valid_importing) do
      -> { ImportedTrainingMessage.import_csv(csv('valid-2'), bot) }
    end

    context 'when invalid csv' do
      let(:file_prefix) do
        'invalid'
      end

      it 'returns false and current_row' do
        expect(importing.call).to eq([false, 2])
      end

      it 'not creates ImportedTrainingMessage record' do
        expect{importing.call}.to_not change(ImportedTrainingMessage, :count)
      end

      it 'not creates Answer record' do
        expect{importing.call}.to_not change(Answer, :count)
      end
    end

    context 'when valid csv' do
      it 'retuns true wrapped by array' do
        expect(importing.call).to eq([true])
      end

      it 'creates ImportedTrainingMessage record' do
        expect{importing.call}.to change(ImportedTrainingMessage, :count).by(2)
      end

      it 'creates Answer record' do
        expect{importing.call}.to change(Answer, :count).by(2)
      end
    end

    context 'when multiple times with valid csv' do
      before do
        importing.call
      end

      it 'not creates duplicated ImportedTrainingMessage records' do
        expect{importing.call}.to_not change(ImportedTrainingMessage, :count)
      end

      it 'not creates duplicated Answer records' do
        expect{importing.call}.to_not change(Answer, :count)
      end
    end

    context 'when only updated answer csv' do
      before do
        importing.call
      end

      it 'not creates duplicated ImportedTrainingMessage records' do
        expect{updated_valid_importing.call}.to_not change(ImportedTrainingMessage, :count)
      end

      it 'creates new Answer records' do
        expect{updated_valid_importing.call}.to change(Answer, :count).by(1)
      end
    end
  end
end
