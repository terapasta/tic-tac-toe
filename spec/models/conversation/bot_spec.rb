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
        results: [{
          answer_id: answer.id, probability: 0.999
        }]
      })
    end

    it { is_expected.to eq [answer] }
  end
end
