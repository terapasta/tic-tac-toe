require 'rails_helper'

RSpec.describe '/api/bots/:bot_id/answer_inline_images', type: :request do
  let!(:bot) do
    create(:bot)
  end

  let!(:user) do
    create(:user)
  end

  let!(:organization) do
    create(:organization).tap do |org|
      org.user_memberships.create(user: user)
      org.bot_ownerships.create(bot: bot)
    end
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

  describe 'POST /api/bots/:bot_id/answer_inline_images' do
    let(:answer_inline_image_params) do
      {
        answer_inline_image: { file: sample_image }
      }
    end

    subject do
      lambda do
        post "/api/bots/#{bot.id}/answer_inline_images", params: answer_inline_image_params
      end
    end

    it 'AnswerInlineImageが作成される' do
      expect(subject).to change(AnswerInlineImage, :count).by(1)
    end
  end
end