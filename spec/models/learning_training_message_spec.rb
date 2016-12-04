require 'rails_helper'

RSpec.describe LearningTrainingMessage, type: :model do
  describe '.recursive_put' do
    let(:base) { ['ほげほげ'] }
    let(:answer) { create(:answer, body: 'ほげほげの回答') }

    subject do
      CSV.generate do |csv|
        LearningTrainingMessage.recursive_put(csv, base, answer)
      end
    end

    it do
      expect(subject).to eq "ほげほげ,ほげほげの回答\n"
    end

    context '分岐が存在する場合' do
      let!(:next_answer1) { create(:answer, body: 'ほげほげの回答です1') }
      let!(:next_answer2) { create(:answer, body: 'ほげほげの回答です2') }
      before do
        create(:decision_branch, answer: answer, next_answer: next_answer1, body: 'NextAnswer1を選択')
        create(:decision_branch, answer: answer, next_answer: next_answer2, body: 'NextAnswer2を選択')
      end

      it do
        expect(subject).to eq [
          "ほげほげ,ほげほげの回答,NextAnswer1を選択,ほげほげの回答です1\n",
          "ほげほげ,ほげほげの回答,NextAnswer2を選択,ほげほげの回答です2\n",
        ].join
      end
    end

    context '次の回答がない分岐が存在する場合' do
      before { create(:decision_branch, answer: answer, body: 'NextAnswerを選択') }
      it do
        expect(subject).to eq "ほげほげ,ほげほげの回答,NextAnswerを選択\n"
      end
    end
  end

  describe '.amp!' do
    let(:bot) { create(:bot) }
    let!(:learning_training_message) { create(:learning_training_message, bot: bot, question: '社長！一杯どうですか？') }
    before do
      create(:word_mapping, word: '社長', synonym: '代表取締役')
      create(:word_mapping, word: '社長', synonym: 'CEO')
    end

    subject do
      LearningTrainingMessage.amp!(bot)
      bot.learning_training_messages.where(answer_id: learning_training_message.answer_id)
    end

    it '同一回答に対して3つの学習データが登録されていること' do
      expect(subject.count).to eq(3)
    end
  end
end
