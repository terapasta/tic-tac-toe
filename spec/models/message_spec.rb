require 'rails_helper'

RSpec.describe Message, :type => :model do
  let(:answer_success) do
    create(:message)
  end

  let(:answer_success_by_bot) do
    create(:message, speaker: :bot)
  end

  let(:answer_failed) do
    create(:message, :failed)
  end

  let(:answer_failed_by_user) do
    create(:message, :failed_by_user)
  end

  describe 'AnswerFailedOperable' do
    describe 'scope' do
      describe 'answer_failed' do
        subject do
          Message.answer_failed
        end

        before do
          answer_success
          answer_success_by_bot
          answer_failed
        end

        context 'システム由来の回答失敗メッセージが混在する場合' do
          it 'システム由来の回答失敗メッセージが取得できること' do
            expect(Message.count()).to eq(3)
            expect(subject.count()).to eq(1)
          end
        end

        context 'システム・ユーザー由来の回答失敗メッセージが混在する場合' do
          before do
            answer_failed_by_user
          end

          it 'システム・ユーザー由来、どちらのメッセージも取得できること' do
            expect(Message.count()).to eq(4)
            expect(subject.count()).to eq(2)
          end
        end
      end
    end

    describe '#save_to_answer_failed' do
      context '回答失敗に変更できる場合' do
        it 'Botの回答成功メッセージであれば回答失敗に変更できること' do
          expect(answer_success_by_bot.save_to_answer_succeed).to be
        end
      end

      context '回答失敗に変更できない場合' do
        it 'Bot以外の回答成功メッセージは回答失敗に変更できないこと' do
          expect(answer_success.save_to_answer_failed).not_to be
          expect(answer_success.errors[:only_bot_message_allowed_answer_status_changing].size).to eq(1)
        end
      end
    end

    describe '#save_to_answer_succeed' do
      context '回答成功に変更できる場合' do
        it 'ユーザーが回答失敗に変更したメッセージを回答成功にできること' do
          expect(answer_failed_by_user.save_to_answer_succeed).to be
        end
      end

      context '回答成功に変更できない場合' do
        it 'Botによって回答失敗とされたメッセージを回答成功にできないこと' do
          expect(answer_failed.save_to_answer_succeed).not_to be
          expect(answer_failed.errors[:only_answer_failed_by_user].size).to eq(1)
        end
      end
    end

    describe '#update' do
      context '更新成功する場合' do
        it 'メッセージ本文を変更できること' do
          expect(answer_success.update(body: 'changed body')).to be
        end
      end

      context '更新失敗する場合' do
        it '内部の回答失敗属性が不整合な状態で回答成功に変更できないこと' do
          expect(answer_failed_by_user.update(body: 'changed body', answer_failed: false)).not_to be
          expect(answer_failed_by_user.errors[:irregular_answer_failed_by_user].size).to eq(1)
        end
      end
    end
  end
end
