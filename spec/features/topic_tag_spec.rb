require 'rails_helper'

RSpec.describe 'Q&Aトピックの検索テスト', type: :feature, js: true do
  include RequestSpecHelper
  include CapybaraHelpers

  let!(:user) do
    create(:user, role: :worker)
  end

  let!(:question_answer) do
    create(:question_answer, bot: bot)
  end

  let!(:bot) do
    create(:bot, user: user)
  end

  let(:topic_tag_attrs) do
    attributes_for(:topic_tag)
  end

  before do
    sign_in user
  end

  describe 'Crud test of TopicTag' do
    scenario 'display Q&A topic' do
      visit bot_topic_tags_path(bot)
    end

    scenario 'Create item' do
      expect{
        visit bot_topic_tags_path(bot)
        click_on 'トピックタグを追加'
        fill_in_input selector: '[type="text"][name^="bot[topic_tags_attributes]"]', value: topic_tag_attrs[:name]
        click_on '更新する'
      }.to change(TopicTag, :count).by(1)
    end

    scenario 'Create invalid item' do
      visit bot_topic_tags_path(bot)
        click_on 'トピックタグを追加'
        click_on '更新する'
      expect(page).to have_content '更新できませんでした。'
    end

    xscenario 'Delete item' do
      visit bot_topic_tags_path(bot)
      click_on 'トピックタグを追加'
      fill_in_input selector: '[type="text"][name^="bot[topic_tags_attributes]"]', value: topic_tag_attrs[:name]
      click_on '更新する'
      expect{
        click_on '削除'
        page.save_screenshot
        click_on '更新する'
        expect(page).to have_content '更新しました'
      }.to change(TopicTag, :count).by(-1)
    end

    scenario 'Update item'  do
      visit bot_topic_tags_path(bot)
      click_on 'トピックタグを追加'
      fill_in_input selector: '[type="text"][name^="bot[topic_tags_attributes]"]', value: topic_tag_attrs[:name]
      click_on '更新する'
      fill_in_input selector: '[type="text"][name^="bot[topic_tags_attributes]"]', value: 'fugafuga'
      click_on '更新する'
      expect(page).to have_content '更新しました'
      updated_topic_tag = TopicTag.last
      expect(topic_tag_attrs[:name]).not_to eq updated_topic_tag.name
    end
  end
end
