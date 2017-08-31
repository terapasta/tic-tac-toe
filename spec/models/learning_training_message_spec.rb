require 'rails_helper'

RSpec.describe LearningTrainingMessage, type: :model do
  describe '.amp!' do
    let(:bot) do
      create(:bot)
    end

    let!(:learning_training_message) do
      create(:learning_training_message, bot: bot, question: '社長！一杯どうですか？')
    end

    let!(:word_mappings) do
      [
        create(:word_mapping, word: '社長', synonym: '代表取締役'),
        create(:word_mapping, word: '社長', synonym: 'CEO'),
      ]
    end

    before do
      LearningTrainingMessage.amp!(bot)
    end

    subject do
      bot.learning_training_messages
    end

    it '同一回答に対して3つの学習データが登録されていること' do
      expect(subject.count).to eq(3)
    end
  end
end
