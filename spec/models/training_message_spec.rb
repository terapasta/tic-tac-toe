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
end
