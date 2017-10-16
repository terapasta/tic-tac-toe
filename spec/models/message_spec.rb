require 'rails_helper'

RSpec.describe Message, :type => :model do
  let(:answer_success_by_bot) do
    create(:message, speaker: :bot)
  end

  let(:answer_failed_by_bot) do
    create(:message, :failed)
  end

  describe 'AnswerMarkable' do
    describe '#save_to_answer_marked' do
      context 'ピンできる場合' do
        it 'Botの回答メッセージであればピンできること' do
          expect(answer_success_by_bot.save_to_answer_marked).to be
          expect(answer_failed_by_bot.save_to_answer_marked).to be
        end
      end

      context 'ピンできない場合' do
        let(:guest_message) do
          create(:message)
        end

        it 'Bot以外のメッセージはピンできないこと' do
          expect(guest_message.save_to_answer_marked).not_to be
        end
      end
    end

    describe '#save_to_remove_answer_marked' do
      context 'ピンの取り消しができる場合' do
        it 'Botの回答メッセージであればピンの取り消し状態にできること' do
          expect(answer_success_by_bot.save_to_remove_answer_marked).to be
          expect(answer_failed_by_bot.save_to_remove_answer_marked).to be
        end
      end

      context 'ピンの取り消しができない場合' do
        let(:answer_marked_by_guest) do
          create(:message, answer_marked: true)
        end

        it 'Bot以外のメッセージはピンの取り消し状態にできないこと' do
          # botのメッセージ以外はピンできないので、本来は発生しないケース
          expect(answer_marked_by_guest.save_to_remove_answer_marked).not_to be
        end
      end
    end

    describe '#update' do
      context '更新成功する場合' do
        it 'メッセージ本文を変更できること' do
          expect{
            answer_success_by_bot.update(body: 'changed body')
          }.to change(answer_success_by_bot, :body).to('changed body')
        end
      end
    end
  end
end
