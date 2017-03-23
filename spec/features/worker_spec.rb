require 'rails_helper'

feature 'worker作業画面の確認', js: true do
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
    fill_in 'Eメール', with: user.email
    fill_in 'パスワード', with: 'hogehoge'
    click_on 'ログイン'
  end

  scenario 'スキップした場合' do
    visit new_imported_sentence_synonym_path
    find('#cancel').click
    expect(current_path).to eq '/imported_sentence_synonyms/new'
  end

  scenario '同義文がブランクの場合の登録' do
    visit new_imported_sentence_synonym_path
    find('#submit').click
    expect(current_path).to eq '/imported_sentence_synonyms/new'
  end

  scenario '同義文が入力してある場合の登録' do
    visit new_imported_sentence_synonym_path
    fill_in 'question_answer_sentence_synonyms_attributes_0_body', with: 'test'
    find('#submit').click
    expect(page). to have_content '登録しました。'
  end

end
