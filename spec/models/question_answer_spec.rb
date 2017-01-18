require 'rails_helper'

RSpec.describe QuestionAnswer do
  describe '.import_csv' do
    let!(:bot) do
      create(:bot)
    end

    def csv(file_prefix)
      Rails.root.join("spec/fixtures/#{file_prefix}_question_answers.csv").open
    end

    let(:file_prefix) do # default
      'valid'
    end

    subject(:importing) do
      -> { QuestionAnswer.import_csv(csv(file_prefix), bot) }
    end

    subject(:updated_valid_importing) do
      -> { QuestionAnswer.import_csv(csv('valid-2'), bot) }
    end

    context 'when invalid csv' do
      let(:file_prefix) do
        'invalid'
      end

      it 'returns false and current_row' do
        expect(importing.call).to eq([false, 2])
      end

      it 'not creates QuestionAnswer record' do
        expect{importing.call}.to_not change(QuestionAnswer, :count)
      end

      it 'not creates Answer record' do
        expect{importing.call}.to_not change(Answer, :count)
      end
    end

    context 'when valid csv' do
      it 'retuns true wrapped by array' do
        expect(importing.call).to eq([true])
      end

      it 'creates QuestionAnswer record' do
        expect{importing.call}.to change(QuestionAnswer, :count).by(2)
      end

      it 'creates Answer record' do
        expect{importing.call}.to change(Answer, :count).by(2)
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

      it 'creates new Answer records' do
        expect{updated_valid_importing.call}.to change(Answer, :count).by(1)
      end
    end
  end
end
