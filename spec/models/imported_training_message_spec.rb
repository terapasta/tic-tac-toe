require 'rails_helper'

RSpec.describe ImportedTrainingMessage do
  describe '.import_csv' do
    let!(:bot) do
      create(:bot)
    end

    let(:file) do
      Rails.root.join("spec/fixtures/#{file_prefix}_imported_training_messages.csv").open
    end

    subject do
      ImportedTrainingMessage.import_csv(file, bot)
    end

    context 'when invalid csv' do
      let(:file_prefix) { 'invalid' }

      it 'returns false and current_row' do
        expect(subject).to eq([false, 2])
      end

      it 'not creates ImportedTrainingMessage record' do
        expect{subject}.to_not change(ImportedTrainingMessage, :count)
      end

      it 'not creates Answer record' do
        expect{subject}.to_not change(Answer, :count)
      end
    end

    context 'when valid csv' do
      let(:file_prefix) { 'valid' }

      it 'retuns true wrapped by array' do
        expect(subject).to eq([true])
      end

      it 'creates ImportedTrainingMessage record' do
        expect{subject}.to change(ImportedTrainingMessage, :count).by(2)
      end

      it 'creates Answer record' do
        expect{subject}.to change(Answer, :count).by(2)
      end
    end
  end
end
