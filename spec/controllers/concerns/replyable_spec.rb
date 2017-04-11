require 'rails_helper'

describe Replyable do

  let(:klass) { Struct.new(:replayable) { include Replyable } }
  let(:replayable) { klass.new }

  describe '#enabled_suggest_question?' do
    let!(:service) { create(:service, :enable_suggest_question, bot: bot) }
    let(:bot) { create(:bot) }
    let(:chat) { create(:chat, bot: bot) }
    let(:question) { '質問です。ほげほげ、もげもげ' }
    let(:question_feature_count) { 3 }
    let(:answer) { create(:answer) }
    let(:probability) { Settings.threshold_of_suggest_similar_questions - 0.01 }
    let(:reply) { Conversation::Reply.new(
      answer: answer,
      probability: probability,
      question: question,
      question_feature_count: question_feature_count
    ) }

    # HACK privateメソッドをテストしてしまっているためクラス設計がよくない
    subject { replayable.send(:enabled_suggest_question?, reply, chat) }

    it { is_expected.to be_truthy }

    context '回答のprobabilityがしきい値を超えている場合' do
      let(:probability) { 0.91 }
      it { is_expected.to be_falsey }
    end

    context '質問が5文字以下で、probabilityが0.9未満の場合' do
      let(:question) { '質問です' }
      let(:probability) { 0.89 }
      it { is_expected.to be_truthy }
    end

    context '質問のfeatureのベクトル数が2つ以下で、probabilityが0.9未満の場合' do
      let(:question_feature_count) { 2 }
      let(:probability) { 0.89 }
      it { is_expected.to be_truthy }
    end
  end
end
