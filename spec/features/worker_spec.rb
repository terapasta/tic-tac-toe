require 'rails_helper'

feature 'worker作業画面の確認' do
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

  background do
    visit new_user_session_path
    sign_in user
  end

  context 'スキップした場合' do
    scenario 'display same page' do
      visit new_imported_sentence_synonym_path
      find('#cancel').click
      expect(current_path).to eq '/imported_sentence_synonyms/new'
    end
  end

  context '同義文がブランクの場合の登録' do
    scenario 'same record count' do
      visit new_imported_sentence_synonym_path
      before_sentencesynonym_count = SentenceSynonym.all.count
      find('#submit').click
      expect(before_sentencesynonym_count).to eq SentenceSynonym.all.count
    end
  end

  context '同義文が入力してある場合の登録' do
    scenario 'Message "登録しました。" is displayed' do
      visit new_imported_sentence_synonym_path
      fill_in 'question_answer_sentence_synonyms_attributes_0_body', with: 'test'
      find('#submit').click
      expect(page). to have_content '登録しました。'
    end
  end
end
