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

    scenario 'Message "登録しました。" is displayed' do
      expect{
        visit bot_topic_tags_path(bot)
        click_on '登録する'
        fill_in_input id: 'topic_tag_name', value: topic_tag_attrs[:name]
        click_on '登録する'
        expect(page).to have_content '登録しました'
      }.to change(TopicTag, :count).by(1)
    end

    scenario 'Message "登録できませんでした。" is displayed' do
      visit bot_topic_tags_path(bot)
      click_on '登録する'
      click_on '登録する'
      expect(page).to have_content '登録できませんでした。'
    end

    xscenario 'Message "削除しました。" is displayed' do
      expect{
        visit bot_topic_tags_path(bot)
        click_on '登録する'
        fill_in_input id: 'topic_tag_name', value: topic_tag_attrs[:name]
        click_on '登録する'
      }.to change(TopicTag, :count).by(1)
      expect{
        click_on '削除'
        # page.driver.browser.switch_to.alert.accept
        expect(page).to have_content '削除しました。'
      }.to change(TopicTag, :count).by(-1)
    end

    scenario 'Message "更新しました。" is displayed'  do
      visit bot_topic_tags_path(bot)
      click_on '登録する'
      fill_in_input id: 'topic_tag_name', value: topic_tag_attrs[:name]
      click_on '登録する'
      click_on '編集'
      fill_in_input id: 'topic_tag_name', value: 'fugafuga'
      click_on '更新する'
      expect(page).to have_content '更新しました'
      updated_topic_tag = TopicTag.last
      expect(topic_tag_attrs[:name]).not_to eq updated_topic_tag.name
    end

    scenario 'Message "更新できませんでした。" is displayed'  do
      visit bot_topic_tags_path(bot)
      click_on '登録する'
      fill_in_input id: 'topic_tag_name', value: topic_tag_attrs[:name]
      click_on '登録する'
      click_on '編集'
      fill_in_input id: 'topic_tag_name', value: ''
      click_on '更新する'
      expect(page).to have_content '更新できませんでした。'
    end
  end
end
