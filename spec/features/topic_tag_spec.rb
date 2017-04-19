require 'rails_helper'

feature 'Q&Aトピックの検索テスト' do
  include RequestSpecHelper

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

  background do
    sign_in user
  end

  describe 'Crud test of TopicTag' do
    scenario 'display Q&A topic' do
      visit bot_topic_tags_path(bot)
    end

    scenario 'Message "登録しました。" is displayed' do
      visit bot_topic_tags_path(bot)
      click_on '登録する'
      fill_in 'topic_tag_name', with: topic_tag_attrs[:name]
      expect{ click_on '登録する' }.to change(TopicTag, :count).by(1)
      expect(page).to have_content '登録しました'
    end

    scenario 'Message "登録できませんでした。" is displayed' do
      visit bot_topic_tags_path(bot)
      click_on '登録する'
      click_on '登録する'
      expect(page).to have_content '登録できませんでした。'
    end

    scenario 'Message "削除しました。" is displayed' do
      visit bot_topic_tags_path(bot)
      click_on '登録する'
      fill_in 'topic_tag_name', with: topic_tag_attrs[:name]
      click_on '登録する'
      expect{ click_on '削除' }.to change(TopicTag, :count).by(-1)
      expect(page).to have_content '削除しました。'
    end

    scenario 'Message "更新しました。" is displayed'  do
      visit bot_topic_tags_path(bot)
      click_on '登録する'
      fill_in 'topic_tag_name', with: topic_tag_attrs[:name]
      click_on '登録する'
      click_on '編集'
      fill_in 'topic_tag_name', with: 'fugafuga'
      click_on '更新する'
      expect(page).to have_content '更新しました'
      updated_topic_tag = TopicTag.last
      expect(topic_tag_attrs[:name]).not_to eq updated_topic_tag.name
    end

    scenario 'Message "更新できませんでした。" is displayed'  do
      visit bot_topic_tags_path(bot)
      click_on '登録する'
      fill_in 'topic_tag_name', with: topic_tag_attrs[:name]
      click_on '登録する'
      click_on '編集'
      fill_in 'topic_tag_name', with: ''
      click_on '更新する'
      expect(page).to have_content '更新できませんでした。'
    end
  end
end
