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
        fill_in_input id: 'topic_tag_name', value: topic_tag_attrs[:name]
        find('[type="text"][name^="bot[topic_tags_attributes]"]').set(topic_tag_attrs[:name])
        click_on '更新する'
      }.to change(TopicTag, :count).by(1)
    end

    scenario 'Create invalid item' do
      visit bot_topic_tags_path(bot)
        click_on 'トピックタグを追加'
        click_on '更新する'
      expect(page).to have_content '更新できませんでした。'
    end

<<<<<<< HEAD
    scenario 'Delete item' do
      visit bot_topic_tags_path(bot)
      click_on 'トピックタグを追加'
      find('[type="text"][name^="bot[topic_tags_attributes]"]').set(topic_tag_attrs[:name])
      click_on '更新する'
      expect{
        click_on '削除'
        click_on '更新する'
        expect(page).to have_content '更新しました'
=======
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
>>>>>>> develop
      }.to change(TopicTag, :count).by(-1)
    end

    scenario 'Update item'  do
      visit bot_topic_tags_path(bot)
<<<<<<< HEAD
      click_on 'トピックタグを追加'
      find('[type="text"][name^="bot[topic_tags_attributes]"]').set(topic_tag_attrs[:name])
      click_on '更新する'
      find('[type="text"][name^="bot[topic_tags_attributes]"]').set('fugafuga')
=======
      click_on '登録する'
      fill_in_input id: 'topic_tag_name', value: topic_tag_attrs[:name]
      click_on '登録する'
      click_on '編集'
      fill_in_input id: 'topic_tag_name', value: 'fugafuga'
>>>>>>> develop
      click_on '更新する'
      expect(page).to have_content '更新しました'
      updated_topic_tag = TopicTag.last
      expect(topic_tag_attrs[:name]).not_to eq updated_topic_tag.name
    end
<<<<<<< HEAD
=======

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
>>>>>>> develop
  end
end
