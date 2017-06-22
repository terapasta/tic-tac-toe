require 'rails_helper'

RSpec.describe '/api/bots/:bot_id/topic_tags', type: :request do
  let!(:user) do
    create(:user)
  end

  let!(:other_user) do
    create(:user)
  end

  let!(:staff) do
    create(:user, :staff)
  end

  let!(:bot) do
    create(:bot, user: user)
  end

  let!(:other_bot) do
    create(:bot, user: other_user)
  end

  let!(:topic_tags) do
    create_list(:topic_tag, 2, bot: bot)
  end

  let!(:other_topic_tags) do
    create_list(:topic_tag, 2, bot: other_bot)
  end

  let(:response_json) do
    JSON.parse(response.body)
  end

  describe 'GET #index' do
    let(:resources) do
      "/api/bots/#{target_bot.id}/topic_tags.json"
    end

    context 'when user as normal' do
      before { login_as(user, scope: :user) }

      context 'when own bot' do
        let(:target_bot) { bot }
        it 'returns topic tags' do
          get resources
          expect(response_json["topicTags"].count).to eq(2)
        end
      end

      context 'when other bot' do
        let(:target_bot) { other_bot }
        it 'returns 403' do
          get resources
          expect(response.status).to eq(403)
        end
      end
    end

    context 'when user as staff' do
      before { login_as(staff, scope: :user) }
      let(:target_bot) { bot }
      it 'returns topic tags' do
        get resources
        expect(response_json["topicTags"].count).to eq(2)
      end
    end
  end

  describe 'POST #create' do
    let(:resource) do
      "/api/bots/#{target_bot.id}/topic_tags.json"
    end

    let(:params) do
      { topic_tag: { name: tag_name } }
    end

    context 'when login as normal' do
      before { login_as(user, scope: :user)}

      context 'when own bot' do
        let(:target_bot) { bot }

        context 'when new tag name' do
          let(:tag_name) { 'new tag' }
          it 'creates record' do
            expect{post resource, params}.to change(TopicTag, :count).by(1)
          end
        end

        context 'when exists tag name' do
          let(:tag_name) { topic_tags.first.name }
          it 'returns exsists topic tag' do
            expect{post resource, params}.to_not change(TopicTag, :count)
          end
        end
      end

      context 'when other bot' do
        let(:target_bot) { other_bot }
        it 'returns 403' do
          post resource
          expect(response.status).to eq(403)
        end
      end
    end

    context 'when login as staff' do
      before { login_as(staff, scope: :user) }

      context 'when new tag name' do
        let(:target_bot) { bot }
        let(:tag_name) { 'new tag' }

        it 'creates new record' do
          expect{post resource, params}.to change(TopicTag, :count).by(1)
        end
      end
    end
  end
end
