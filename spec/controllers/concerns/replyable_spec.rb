require 'rails_helper'

describe Replyable do

  let(:klass) { Struct.new(:replayable) { include Replyable } }
  let(:replayable) { klass.new }

  describe '#enabled_suggest_question?' do
    let!(:service) { create(:service, :enable_suggest_question, bot: bot) }
    let(:bot) { create(:bot) }
    let(:chat) { create(:chat, bot: bot) }
    let(:answer) { create(:answer) }
    let(:probability) { Settings.threshold_of_suggest_similar_questions - 0.01 }
    let(:reply_answer) { Conversation::ReplyAnswer.new(answer, probability) }

    # HACK privateメソッドをテストしてしまっているためクラス設計がよくない
    subject { replayable.send(:enabled_suggest_question?, reply_answer, chat) }

    it { is_expected.to be_truthy }
  end
end
