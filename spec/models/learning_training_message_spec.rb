require 'rails_helper'

RSpec.describe LearningTrainingMessage, type: :model do
  describe '.to_csv' do
    pending
  end

  describe '.recursive_put' do
    pending
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
