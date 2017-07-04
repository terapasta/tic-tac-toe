require 'rails_helper'

RSpec.describe QuestionAnswer::CsvImporter do
  let(:csv_file) { fixture_file_upload csv_path, 'text/csv' }
  let(:importer) do
    QuestionAnswer::CsvImporter.new(csv_file, bot, import_options)
  end

  describe '#import' do
    let(:bot) { create(:bot) }

    subject do
      importer.import
      importer
    end

    context 'SJISエンコードの正しいCSVをインポートする場合' do
      let(:csv_path) { 'sjis_valid_question_answers.csv' }
      let(:import_options) do
        { is_utf8: false }
      end

      context '既存データが0件の場合' do
        let!(:succeeded) { subject.succeeded }

        it '正常終了すること' do
          expect(succeeded).to be_truthy
        end

        it '2件のQuestionAnserが登録されること' do
          expect(QuestionAnswer.count).to eq 2
        end
        it '4件のAnserが登録されること' do
          expect(Answer.count).to eq 4
        end
        it '2件のDecisionBranchが登録されること' do
          expect(DecisionBranch.count).to eq 2
        end
      end

      context 'id=1のQuestionAnswerが登録済の場合' do
        let!(:question_answer) do
          create(:question_answer, id: 1, bot_id: bot.id)
        end

        let!(:succeeded) { subject.succeeded }

        it '正常終了すること' do
          expect(succeeded).to be_truthy
        end

        it '2件のQuestionAnserが登録されていること' do
          expect(QuestionAnswer.count).to eq 2
        end
        it '4件のAnserが登録されていること' do
          expect(Answer.count).to eq 4
        end
        it '2件のDecisionBranchが登録されていること' do
          expect(DecisionBranch.count).to eq 2
        end
      end

      context '違うボットがid=1のQuestionAnswerを登録済の場合' do
        let(:bot2) { create(:bot) }
        let!(:question_answer) do
          create(:question_answer, id: 1, bot_id: bot2.id)
        end

        let!(:succeeded) { subject.succeeded }

        it '正常終了すること' do
          expect(succeeded).to be_truthy
        end

        it '3件のQuestionAnserが登録されていること' do
          expect(bot.question_answers.count).to eq 2
          expect(bot2.question_answers.count).to eq 1
        end
        it '4件のAnserが登録されていること' do
          expect(Answer.count).to eq 4
        end
        it '2件のDecisionBranchが登録されていること' do
          expect(DecisionBranch.count).to eq 2
        end
      end
    end


  end
end
