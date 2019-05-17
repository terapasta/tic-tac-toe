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

        it 'QuestionAnswerが登録されること' do
          expect(bot.question_answers.count).to eq 5
        end
      end

      context 'id=1のQuestionAnswerが登録済の場合' do
        let!(:question_answer) do
          create(:question_answer, id: 1, bot_id: bot.id)
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

        it 'QuestionAnswerが登録されていること' do
          expect(bot.question_answers.count).to eq 5
          expect(bot2.question_answers.count).to eq 1
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

      it 'QuestionAnswerが登録されないこと' do
        expect(bot.question_answers.count).to eq 0
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

    end

    context 'トピックタグのインポートをする場合' do
      let(:csv_path) { 'sjis_valid-5_question_answers.csv' }
      let(:import_options) do
        { is_utf8: false }
      end

      let!(:topic_tag) do
        create(:topic_tag, bot: bot, name: 'hoge')
      end

      it '正常終了すること' do
        expect(subject.succeeded).to be_truthy
      end

      it '新しいトピックタグが登録されること' do
        expect { subject }.to change(bot.topic_tags, :count).from(1).to(2)
        expect(QuestionAnswer.first.topic_tags.count).to eq 2
      end
    end

    context 'データ内に重複した質問が含まれるCSVをインポートする場合' do
      let(:csv_path) { 'sjis_invalid-4_question_answers.csv' }
      let(:import_options) do
        { is_utf8: false }
      end

      it '正常終了しないこと' do
        expect(subject.succeeded).to be_falsey
      end

      it 'QuestionAnswerが登録されないこと' do
        expect(bot.question_answers.count).to eq 0
      end
    end

    context '質問が登録済みで、そのidがCSVデータ内に含まれていないものをインポートする場合' do
      let(:csv_path) { 'sjis_invalid-5_question_answers.csv' }
      let(:import_options) do
        { is_utf8: false }
      end

      let!(:question_answer) do
        create(:question_answer, id: 1, bot_id: bot.id, question: "クエスチョン1")
      end

      it '正常終了しないこと' do
        expect(subject.succeeded).to be_falsey
      end

      it 'QuestionAnswerが登録されないこと' do
        expect(bot.question_answers.count).to eq 1
      end
    end
  end
end
