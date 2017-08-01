require 'rails_helper'

RSpec.describe QuestionAnswer::CsvImporter do
  let(:csv_file) { fixture_file_upload csv_path, 'text/csv' }
  let(:importer) do
    QuestionAnswer::CsvImporter.new(csv_file, bot, import_options)
  end

  describe '#import' do
    let(:bot) { create(:bot, id: 1) }

    subject do
      importer.import
      importer
    end

    context 'SJISエンコードの正しいCSVをインポートする場合' do
      let(:csv_path) { 'sjis_valid-3_question_answers.csv' }
      let(:import_options) do
        { is_utf8: false }
      end

      context '既存データが0件の場合' do
        let!(:succeeded) { subject.succeeded }

        it '正常終了すること' do
          expect(succeeded).to be_truthy
        end

        it 'QuestionAnserが登録されること' do
          expect(bot.question_answers.count).to eq 2
        end
        it 'DecisionBranchが登録されること' do
          expect(bot.decision_branches.count).to eq 4
        end
      end

      context 'id=1のQuestionAnswerが登録済の場合' do
        let!(:question_answer) do
          create(:question_answer, id: 1, bot_id: bot.id)
        end

        context 'answerの無いDecisionBranchが登録済の場合' do
          before do
            create(:decision_branch, bot_id: bot.id, question_answer_id: question_answer.id, body: 'それ以降1-1')
            question_answer.save
          end
          let!(:succeeded) { subject.succeeded }

          it '正常終了すること' do
            expect(succeeded).to be_truthy
          end

          it 'QuestionAnserが登録されること' do
            expect(bot.question_answers.count).to eq 2
          end
          it 'DecisionBranchが登録されること' do
            expect(bot.decision_branches.count).to eq 4
            expect(question_answer.decision_branches.first.answer).to eq 'それ以降1-2'
          end
        end

        context 'answerをもつDecisionBranchが登録済の場合' do
          let!(:decision_branch) do
            create(:decision_branch, bot_id: bot.id, question_answer_id: question_answer.id, body: 'それ以降2-1', answer: 'ほげほげ')
          end
          let!(:succeeded) { subject.succeeded }

          it '正常終了すること' do
            expect(succeeded).to be_truthy
          end

          it 'QuestionAnserが登録されること' do
            expect(bot.question_answers.count).to eq 2
          end
          it 'DecisionBranchが登録されること' do
            expect(bot.decision_branches.count).to eq 4
          end
          it 'DecisionBranchが更新されること' do
            expect(decision_branch.reload.answer).to eq 'それ以降2-2'
          end
        end
      end

      context '違うボットがid=1のQuestionAnswerを登録済の場合' do
        let!(:bot2) { create(:bot, id: 2) }
        let!(:question_answer) do
          create(:question_answer, id: 1, bot_id: bot2.id)
        end

        let!(:succeeded) { subject.succeeded }

        it '正常終了すること' do
          expect(succeeded).to be_truthy
        end

        it 'QuestionAnserが登録されていること' do
          expect(bot.question_answers.count).to eq 2
          expect(bot2.question_answers.count).to eq 1
        end
        it 'DecisionBranchが登録されていること' do
          expect(bot.decision_branches.count).to eq 4
        end
      end


    end

    context 'SJISエンコードのアンサーが空であるデータを含むCSVをインポートする場合' do
      let(:csv_path) { 'sjis_invalid-2_question_answers.csv' }
      let(:import_options) do
        { is_utf8: false }
      end
      let!(:succeeded) { subject.succeeded }

      it '正常終了しないこと' do
        expect(succeeded).to be_falsey
      end

      it 'QuestionAnserが登録されないこと' do
        expect(bot.question_answers.count).to eq 0
      end
      it 'DecisionBranchが登録されないこと' do
        expect(bot.decision_branches.count).to eq 0
      end

    end

    context 'SJISエンコードのid列が文字列であるデータを含むCSVをインポートする場合' do
      let(:csv_path) { 'sjis_invalid-3_question_answers.csv' }
      let(:import_options) do
        { is_utf8: false }
      end
      let!(:succeeded) { subject.succeeded }

      it '正常終了すること' do
        expect(succeeded).to be_truthy
      end

      it 'QuestionAnserが登録されていること' do
        expect(bot.question_answers.count).to eq 2
      end
      it 'DecisionBranchが登録されていること' do
        expect(bot.decision_branches.count).to eq 2
      end

    end
  end
end
