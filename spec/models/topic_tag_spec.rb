require 'rails_helper'

RSpec.describe TopicTag do
  include RequestSpecHelper

  let!(:user) do
    create(:user, role: :worker)
  end

  let!(:bot) do
    create(:bot)
  end

  let!(:organization) do
    create(:organization, plan: :professional).tap do |org|
      org.user_memberships.create(user: user)
      org.bot_ownerships.create(bot: bot)
    end
  end

  context 'topicTagモデルテスト' do
    it 'should be valid' do
      topic_tag = TopicTag.new(name: 'テスト', bot_id: 1)
      expect(topic_tag).to be_valid
    end
  end

  describe 'without_by_id scope' do
    let!(:topic_tags) do
      create_list(:topic_tag, 2, bot: bot)
    end

    subject do
      TopicTag.without_by_id(topic_tags.first.id)
    end

    it 'returns records that without specified id' do
      expect(subject).to match_array([topic_tags.second])
    end
  end
end
