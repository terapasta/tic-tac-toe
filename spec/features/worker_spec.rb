require 'rails_helper'

feature 'worker作業の挙動確認' do
  scenario 'スキップした場合' do
    visit new_imported_sentence_synonym_path
    click_on 'スキップする'
    expect(current_path).to eq '/imported_sentence_synonyms/new'
  end

  scenario '同義文がブランクの場合の登録' do
    visit new_imported_sentence_synonym_path
    expect(current_path).to eq '/imported_sentence_synonyms/new'
  end

  scenario '同義文が記述してある場合の登録' do
    visit new_imported_sentence_synonym_path
    fill_in "Body", with: "test"
    click_on '登録する'
    expect(page). to have_content '登録しました。'
    expect(current_path).to eq '/imported_sentence_synonyms/new'
  end
end
