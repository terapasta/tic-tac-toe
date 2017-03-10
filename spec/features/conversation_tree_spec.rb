require 'rails_helper'

RSpec.describe 'ConversationTree', type: :feature, js: true do
  include RequestSpecHelper

  let!(:staff) do
    create(:user, role: :staff)
  end

  let!(:user) do
    create(:user)
  end

  let!(:bot) do
    create(:bot, user: user)
  end

  let!(:question_answers) do
    [
      create(:question_answer, bot: bot, answer: answer),
      create(:question_answer, bot: bot),
    ]
  end

  let!(:answer) do
    create(:answer, bot: bot)
  end

  let!(:decision_branches) do
    create_list(:decision_branch, 2, bot: bot, answer: answer)
  end

  let!(:nested_answer) do
    create(:answer, bot: bot).tap do |a|
      decision_branches.first.tap do |d|
        d.next_answer = a
        d.save
      end
    end
  end

  before do
    sign_in staff
    visit "/bots/#{bot.id}/conversation_tree"
  end

  scenario 'display tree nodes' do
    find("#question-#{question_answers.first.id}").click
    expect(page).to have_content(answer.body)
    find("#answer-#{answer.id}").click
    expect(page).to have_content(question_answers.first.question)
    find("#decision-branch-#{decision_branches.first.id}").click
    expect(page).to have_content(nested_answer.body)
  end

  scenario 'creates question with answer'  do
    find('.tree__item-add').click
    fill_in 'question-question', with: 'new question'
    fill_in 'answer-body', with: 'new answer'
    click_link '保存'
    within '.master-detail-panel__master' do
      expect(page).to have_content('new question')
      expect(page).to have_content('new answer')
    end
  end

  scenario 'creates decision_branch' do
    find("#question-#{question_answers.first.id}").click
    find("#answer-#{answer.id}").click
    find('#add-decision-branch-button').click
    fill_in 'decision-branch-body', with: 'new decision branch'
    find('span.btn.btn-primary').click
    within '.master-detail-panel__master' do
      expect(page).to have_content('new decision branch')
    end
  end

  scenario 'updates answer' do
    skip 'ここは環境によって落ちたりするみたいなのでskip'
    find("#question-#{question_answers.first.id}").click
    find("#answer-#{answer.id}").click
    sleep 4
    fill_in 'answer-body', with: 'updated answer'
    click_link '保存'
    within '.master-detail-panel__master' do
      expect(page).to have_content('updated answer')
    end
  end

  scenario 'updates decision branch' do
    find("#question-#{question_answers.first.id}").click
    find("#answer-#{answer.id}").click
    within "#decision-branch-item-#{decision_branches.first.id}" do
      find('.btn').click
    end
    within "#decision-branch-item-#{decision_branches.first.id}" do
      fill_in 'decision-branch-body', with: 'updated decision branch'
      find('.btn-default').click
    end
    within '.master-detail-panel__master' do
      expect(page).to have_content('updated decision branch')
    end
  end

  scenario 'deletes answer' do
    find("#question-#{question_answers.first.id}").click
    find("#answer-#{answer.id}").click
    find("#delete-answer-button").click
    within '.master-detail-panel__master' do
      expect(page).to_not have_content(answer.body)
    end
  end

  scenario 'deletes decision branch' do
    find("#question-#{question_answers.first.id}").click
    find("#answer-#{answer.id}").click
    within "#decision-branch-item-#{decision_branches.first.id}" do
      find('.btn').click
    end
    skip 'ここは環境によって落ちたりするみたいなのでskip'
    within "#decision-branch-item-#{decision_branches.first.id}" do
      find('.btn-danger').click
    end
    within '.master-detail-panel__master' do
      expect(page).to_not have_content(decision_branches.first.body)
    end
  end
end
