require 'rails_helper'

RSpec.describe 'AnswerFiles spec', type: :request do
  let!(:user) do
    create(:user)
  end

  let!(:bot) do
    create(:bot)
  end

  let!(:organization) do
    create(:organization).tap do |org|
      org.user_memberships.create(user: user)
      org.bot_ownerships.create(bot: bot)
    end
  end

  let!(:question_answer) do
    create(:question_answer, bot: bot)
  end

  let!(:answer_file) do
    create(:answer_file, question_answer: question_answer, file: sample_image_path.open)
  end

  let(:sample_image_path) do
    Rails.root.join('spec/fixtures/images/sample_naoki.jpg')
  end

  let(:sample_image) do
    fixture_file_upload(sample_image_path, 'image/jpg')
  end

  before do
    login_as(user, scope: :user)
  end

  describe 'POST /api/bots/:bot_id/question_answers/:question_answer_id/answer_files' do
    subject do
      lambda do
        post "/api/bots/#{bot.id}/question_answers/#{question_answer.id}/answer_files", params: {
          answer_file: { file: sample_image }
        }
      end
    end

    it 'creates answer_file record' do
      expect(subject).to change(AnswerFile, :count).by(1)
    end
  end

  describe 'DELETE /api/bots/:bot_id/question_answers/:question_answer_id/answer_files/:id' do
    subject do
      lambda do
        delete "/api/bots/#{bot.id}/question_answers/#{question_answer.id}/answer_files/#{answer_file.id}"
      end
    end

    it 'deletes answer_file record' do
      expect(subject).to change(AnswerFile, :count).by(-1)
    end
  end
end