require 'rails_helper'

RSpec.describe Conversation::Bot do
  describe '#reply' do
    let(:bot) { create(:bot) }
    let(:answer) { create(:answer, bot: bot) }
    let(:message) { create(:message) }
    let(:conversation_bot) { Conversation::Bot.new(bot, message) }
    subject { conversation_bot.reply }

    before do
      Ml::Engine.any_instance.stub(:reply).and_return({
        answer_id: answer.id,
        probability: 0.999,
        results: []
      })
    end

    it { expect(subject.first.answer).to eq answer }

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
        expect(subject.first.answer).to be_a NullAnswer
      end
    end
  end
end
