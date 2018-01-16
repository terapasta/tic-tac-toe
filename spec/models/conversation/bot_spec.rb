require 'rails_helper'

RSpec.describe Conversation::Bot do
  let(:bot) { create(:bot) }
  let(:question_answer) { create(:question_answer, bot: bot) }
  let(:message) { create(:message) }
  let(:conversation_bot) { Conversation::Bot.new(bot, message) }
  let(:dummy_ml_engine) { double('dummy ml engine').as_null_object }

  before do
    allow(Ml::Engine).to receive(:new) { dummy_ml_engine }
  end

  describe '#reply' do
    subject { conversation_bot.do_reply }

    before do
      allow(dummy_ml_engine).to receive(:reply).and_return({
        question_feature_count: 1,
        results: [
          { question_answer_id: question_answer.id, probability: 0.999 },
          { question_answer_id: 999, probability: 0.3 },
        ]
      })
    end

    it { expect(subject.question_answer).to eq question_answer }

    context '#replyの結果のanswer_idが0の場合' do
      before do
        allow(dummy_ml_engine).to receive(:reply).and_return({
          answer_id: QuestionAnswer::NO_CLASSIFIED_ID,
          probability: 1.0,
          results: []
        })
      end

      it 'NullAnswerが返ること' do
        # TODO: NullQuestionAnswerに置き換える
        expect(subject.question_answer).to be_a NullQuestionAnswer
      end
    end
  end

  # describe '#similar_question_answers_in' do
  #   let (:ids) { [2, 1] }
  #   let (:first_question_answer) {create(:question_answer, id: 1)}
  #   let (:second_question_answer) {create(:question_answer, id: 2)}
  #   subject { conversation_bot.similar_question_answers_in(ids) }

  #   before do
  #     bot.question_answers << first_question_answer
  #     bot.question_answers << second_question_answer
  #     bot.save
  #   end

  #   it '引数で指定したidの順番通りに取得できること' do
  #     is_expected.to eq [second_question_answer, first_question_answer]
  #   end
  # end
end
