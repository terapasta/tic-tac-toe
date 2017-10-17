require 'rails_helper'

RSpec.describe '/api/bots/:bot_id/question_answers/:question_answer_id/topic_taggings', type: :request do
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
    create(:bot)
  end

  let!(:other_bot) do
    create(:bot)
  end

  let!(:topic_tags) do
    create_list(:topic_tag, 2, bot: bot)
  end

  let!(:other_topic_tags) do
    create_list(:topic_tag, 2, bot: other_bot)
  end

  let!(:question_answer) do
    create(:question_answer, bot: bot)
  end

  let!(:other_question_answer) do
    create(:question_answer, bot: other_bot)
  end

  let!(:topic_taggings) do
    topic_tags.map{ |topic_tag|
      question_answer.topic_taggings.create(topic_tag: topic_tag)
    }
  end

  let!(:other_topic_taggings) do
    other_topic_tags.map{ |topic_tag|
      other_question_answer.topic_taggings.create(topic_tag: topic_tag)
    }
  end

  let!(:organization) do
    create(:organization, plan: :professional).tap do |org|
      org.user_memberships.create(user: user)
      org.bot_ownerships.create(bot: bot)
    end
  end

  let!(:other_organization) do
    create(:organization, plan: :professional).tap do |org|
      org.user_memberships.create(user: other_user)
      org.bot_ownerships.create(bot: other_bot)
    end
  end

  let(:response_json) do
    JSON.parse(response.body)
  end

  describe 'GET #index' do
    let(:resources) do
      "/api/bots/#{target_bot.id}/question_answers/#{target_question_answer.id}/topic_taggings.json"
    end

    context 'when login as user' do
      before { login_as(user, scope: :user) }

      context 'when own bot' do
        let(:target_bot) { bot }
        let(:target_question_answer) { question_answer }

        it 'returns bot' do
          get resources
          expect(response_json['topicTaggings'].count).to eq(2)
        end
      end

      context 'when other bot' do
        let(:target_bot) { other_bot }
        let(:target_question_answer) { other_question_answer }

        it 'returns 403' do
          get resources
          expect(response.status).to eq(403)
        end
      end
    end

    context 'when login as staff' do
      before { login_as(staff, scope: :user) }

      let(:target_bot) { bot }
      let(:target_question_answer) { question_answer }

      it 'returns record' do
        get resources
        expect(response_json['topicTaggings'].count).to eq(2)
      end
    end
  end

  describe 'POST #create' do
    let(:resources) do
      "/api/bots/#{target_bot.id}/question_answers/#{target_question_answer.id}/topic_taggings.json"
    end

    let(:params) do
      { topic_tagging: { topic_tag_id: topic_tag.id } }
    end

    context 'when login as normal' do
      before { login_as(user, scope: :user) }

      context 'when own bot' do
        let(:target_bot) { bot }
        let(:target_question_answer) { question_answer }
        let!(:topic_tag) { create(:topic_tag, bot: target_bot) }

        it 'creates record' do
          expect{post resources, params}.to change(TopicTagging, :count).by(1)
        end
      end

      context 'when other bot' do
        let(:target_bot) { other_bot }
        let(:target_question_answer) { other_question_answer }
        let!(:topic_tag) { create(:topic_tag, bot: target_bot) }

        it 'returns 403' do
          post resources, params
          expect(response.status).to eq(403)
        end
      end
    end

    context 'when login as staff' do
      before { login_as(staff, scope: :user) }

      it 'creates record' do

      end
    end
  end

  describe 'DELETE #destroy' do
    let(:resource) do
      "/api/bots/#{target_bot.id}/question_answers/#{target_question_answer.id}/topic_taggings/#{target_topic_tagging.id}.json"
    end

    context 'when login as normal' do
      before { login_as(user, scope: :user) }

      context 'when own bot' do
        let(:target_bot) { bot }
        let(:target_question_answer) { question_answer }
        let(:target_topic_tagging) { topic_taggings.first }

        it 'deletes record' do
          expect{delete resource}.to change(TopicTagging, :count).by(-1)
        end
      end

      context 'when other bot' do
        let(:target_bot) { other_bot }
        let(:target_question_answer) { other_question_answer }
        let(:target_topic_tagging) { other_topic_taggings.first }

        it 'returns 403' do
          delete resource
          expect(response.status).to eq(403)
        end
      end
    end

    context 'when login as staff' do
      before { login_as(staff, scope: :user)}

      let(:target_bot) { bot }
      let(:target_question_answer) { question_answer }
      let(:target_topic_tagging) { topic_taggings.first }

      it 'deletes record' do
        expect{delete resource}.to change(TopicTagging, :count).by(-1)
      end
    end
  end
end
