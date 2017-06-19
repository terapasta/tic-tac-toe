require 'rails_helper'

RSpec.describe Conversation::Bot do
  let(:bot) { create(:bot) }
  let(:answer) { create(:answer, bot: bot) }
  let(:message) { create(:message) }
  let(:conversation_bot) { Conversation::Bot.new(bot, message) }

  describe '#reply' do
    subject { conversation_bot.do_reply }

    before do
      allow_any_instance_of(Ml::Engine).to receive(:reply).and_return({
        answer_id: answer.id,
        probability: 0.999,
        results: []
      })
    end

    it { expect(subject.answer).to eq answer }

    context '#replyの結果のanswer_idが0の場合' do
      # FIXME DatabaseCleanerでdefined_answerがテストケースごとに削除されてしまうための対処
      # defined_answerはマスタデータなので削除されないようにしたい
      let!(:defined_answer) do
        create(:defined_answer, defined_answer_id: DefinedAnswer::CLASSIFY_FAILED_ID, body: 'hogehoge')
      end

      before do
        Ml::Engine.any_instance.stub(:reply).and_return({
          answer_id: Answer::NO_CLASSIFIED_ID,
          probability: 1.0,
          results: []
        })
      end

      it 'NullAnswerが返ること' do
        expect(subject.answer).to be_a NullAnswer
      end
    end
  end

  describe '#similar_question_answers_in' do
    let (:ids) { [2, 1] }
    let (:first_question_answer) {create(:question_answer, id: 1)}
    let (:second_question_answer) {create(:question_answer, id: 2)}
    subject { conversation_bot.similar_question_answers_in(ids) }

    before do
      bot.question_answers << first_question_answer
      bot.question_answers << second_question_answer
      bot.save
    end

    it '引数で指定したidの順番通りに取得できること' do
      is_expected.to eq [second_question_answer, first_question_answer]
    end
  end
end
