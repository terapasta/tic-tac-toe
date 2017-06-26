require 'rails_helper'

RSpec.describe QuestionAnswersController, type: :controller do
  let!(:user) do
    create(:user)
  end

  let!(:bot) do
    create(:bot, user: user)
  end

  let!(:question_answer) do
    create(:question_answer, bot: bot, answer: answer)
  end

  let!(:answer) do
    create(:answer, bot: bot)
  end

  let(:sample_image) do
    Rack::Test::UploadedFile.new Rails.root.join('spec/fixtures/images/sample_naoki.jpg').open
  end

  describe 'PUT #update' do
    subject do
      lambda do
        put :update, bot_id: bot.id, id: question_answer.id, question_answer: params
      end
    end

    let(:params) do
      {}
    end

    context 'when login as bot owner' do
      before do
        sign_in user
      end

      context 'when question_answer has answer' do
        context 'when not changed answer body' do
          let(:params) do
            {
              question: 'updated question',
              answer_attributes: {
                body: answer.body,
                answer_files_attributes: [{
                  file: sample_image,
                }],
              }
            }
          end

          it { is_expected.to_not change(Answer, :count) }
          it { is_expected.to change(AnswerFile, :count) }
        end

        context 'when changed answer body' do
          let(:params) do
            {
              answer_attributes: {
                body: 'updated answer body',
                answer_files_attributes: [{
                  file: sample_image
                }]
              }
            }
          end

          it { is_expected.to change(Answer, :count).by(1) }
        end
      end

      context 'when question_answer not has answer' do
        before do
          question_answer.answer.destroy
        end

        let(:params) do
          { answer_attributes: { body: "hoge" } }
        end

        it { is_expected.to change(Answer, :count).by(1) }
      end
    end
  end
end
