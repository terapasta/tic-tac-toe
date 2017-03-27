require 'rails_helper'

shared_examples_for CsvGeneratable do
  describe '#recursive_put_rows_to_csv' do
    let(:base) { ['ほげほげ'] }
    let(:answer) { create(:answer, body: 'ほげほげの回答') }

    subject do
      CSV.generate do |csv|
        described_class.send(:recursive_put_rows_to_csv, csv, base, answer)
      end
    end

    it do
      expect(subject).to eq "ほげほげ,ほげほげの回答\n"
    end

    context '分岐が存在する場合' do
      let!(:next_answers) do
        [
          create(:answer, body: 'ほげほげの回答です1'),
          create(:answer, body: 'ほげほげの回答です2'),
        ]
      end

      before do
        create(:decision_branch, answer: answer, next_answer: next_answers.first, body: 'NextAnswer1を選択')
        create(:decision_branch, answer: answer, next_answer: next_answers.second, body: 'NextAnswer2を選択')
      end

      it do
        expect(subject).to eq [
          "ほげほげ,ほげほげの回答,NextAnswer1を選択,ほげほげの回答です1\n",
          "ほげほげ,ほげほげの回答,NextAnswer2を選択,ほげほげの回答です2\n",
        ].join
      end
    end

    context '次の回答がない分岐が存在する場合' do
      before do
        create(:decision_branch, answer: answer, body: 'NextAnswerを選択')
      end

      it do
        expect(subject).to eq "ほげほげ,ほげほげの回答,NextAnswerを選択\n"
      end
    end
  end
end

describe QuestionAnswersDecorator.new([]) do
  it_behaves_like CsvGeneratable
end
