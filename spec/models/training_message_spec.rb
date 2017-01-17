require 'rails_helper'

RSpec.describe TrainingMessage, :type => :model do
  describe '.pick_sentence_synonyms_not_enough' do
    let(:user) { create(:user) }
    let(:bot) { create(:bot) }
    let(:training) { create(:training, bot: bot) }
    let!(:training_message1) { create(:training_message, training: training) }
    let!(:training_message2) { create(:training_message, training: training) }

    subject { TrainingMessage.pick_sentence_synonyms_not_enough(bot, user) }

    context 'training_message1にsentence_synonymsが20件登録されている場合' do
      before do
        20.times { training_message1.sentence_synonyms.create!(body: 'hoge', created_user_id: 999) }
      end

      it 'training_message2が取得されること' do
        is_expected.to eq training_message2
      end
    end

    context 'training_message1nのsentence_synonymsにuserが登録したデータが3件含まれる場合' do
      before do
        3.times do
          training_message1.sentence_synonyms.create!(body: 'hoge', created_user: user)
        end
      end

      it '何度取得してもtraining_message2が取得されること' do
        10.times do
          expect(TrainingMessage.pick_sentence_synonyms_not_enough(bot, user)).to eq(training_message2)
        end
      end
    end
  end

  describe 'after_create' do
    let(:answer) { build(:answer, body: '元気ですよ。あなたは？') }
    let(:training) { create(:training, training_messages: [
      build(:training_message, speaker: :guest, body: 'こんにちは元気ですか？'),
    ])}

    subject do
      training_message = training.training_messages.create(
        speaker: :bot, body: answer.body, answer: answer)
      training_message.reload.imported_training_message
    end

    it 'Q&Aのセットでimported_training_messageが紐付いていること' do
      expect(subject.question).to eq 'こんにちは元気ですか？'
      expect(subject.answer).to eq answer
    end
  end

  describe 'after_update' do
    # let(:imported_training_message) { build(:imported_training_message, question: 'こんにちは元気ですか？', answer: answer) }
    let(:answer) { build(:answer, body: '元気ですよ。あなたは？') }
    let(:other_answer) { create(:answer, body: '体調悪いですね。あなたは？') }
    let(:training) { create(:training, training_messages: [
      build(:training_message, speaker: :guest, body: 'こんにちは元気ですか？'),
      build(:training_message, speaker: :bot, body: answer.body, answer: answer),
    ])}

    context 'training_messageの回答が差し替えられた場合' do
      subject do
        training_message = training.training_messages.last
        training_message.update!(answer: other_answer)
        training_message.reload.imported_training_message
      end

      context 'training_messageに紐づくimported_training_messageが存在する場合' do
        it 'imported_training_messageの回答が差し替わること' do
          expect(subject.question).to eq 'こんにちは元気ですか？'
          expect(subject.answer).to eq other_answer
        end
      end

      context 'training_messageに紐づくimported_training_messageが存在しない場合' do
        before do
          training.training_messages.update_all(imported_training_message_id: nil)
        end

        it 'training_messageに紐づくimported_training_messageが存在しないままであること' do
          subject
          training.training_messages.all { |tm| tm.imported_training_message == nil }
        end
      end
    end
  end
end
