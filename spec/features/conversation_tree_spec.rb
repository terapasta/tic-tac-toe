require 'rails_helper'

RSpec.describe 'ConversationTree', type: :feature, js: true do
  include RequestSpecHelper
  include CapybaraHelpers

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
      create(:question_answer, bot: bot),
      create(:question_answer, bot: bot),
    ]
  end

  let!(:decision_branches) do
    create_list(:decision_branch, 2, bot: bot, question_answer: question_answers.first)
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
    find("#question-#{question_answers.first.id}").trigger('click')
    expect(page).to have_content(question_answers.first.answer)
    find("#answer-#{question_answers.first.id}").trigger('click')
    expect(page).to have_content(decision_branches.first.body)
    expect(page).to have_content(decision_branches.second.body)
    find("#decision-branch-#{decision_branches.first.id}").trigger('click')
    expect(page).to have_content(decision_branches.first.answer)
  end

  scenario 'creates question with answer'  do
    find('#adding').click
    fill_in_input name: 'question-question', value: 'new question'
    fill_in_input name: 'question-answer', value: 'new answer'
    click_link '保存'
    within '.master-detail-panel__master' do
      expect(page).to have_content('new question')
      expect(page).to have_content('new answer')
    end
  end

  scenario 'creates decision_branch' do
    find("#question-#{question_answers.first.id}").click
    find("#answer-#{question_answers.first.id}").click
    find('#add-decision-branch-button').click
    fill_in_input name: 'decision-branch-body', value: 'new decision branch'
    find('span.btn.btn-primary').click
    within '.master-detail-panel__master' do
      expect(page).to have_content('new decision branch')
    end
  end

  scenario 'updates answer' do
    find("#question-#{question_answers.first.id}").click
    find("#answer-#{question_answers.first.id}").click
    fill_in_input name: 'answer-body', value: 'updated answer'
    click_link '保存'
    within '.master-detail-panel__master' do
      expect(page).to have_content('updated answer')
    end
  end

  scenario 'updates decision branch' do
    find("#question-#{question_answers.first.id}").trigger('click')
    find("#answer-#{question_answers.first.id}").trigger('click')
    within "#decision-branch-item-#{decision_branches.first.id}" do
      find('.btn').trigger('click')
    end
    within "#decision-branch-item-#{decision_branches.first.id}" do
      fill_in_input name: 'decision-branch-body', value: 'updated decision branch'
      find('.btn-success').click
    end
    within '.master-detail-panel__master' do
      expect(page).to have_content('updated decision branch')
    end
  end

  scenario 'deletes answer' do
    find("#question-#{question_answers.first.id}").click
    find("#answer-#{question_answers.first.id}").click
    find("#delete-answer-button").click
    find("#alert-delete-button").click
    within '.master-detail-panel__master' do
      expect(page).to_not have_content(question_answers.first.answer)
    end
  end

  scenario 'deletes decision branch' do
    find("#question-#{question_answers.first.id}").trigger('click')
    find("#answer-#{question_answers.first.id}").trigger('click')
    within "#decision-branch-item-#{decision_branches.first.id}" do
      find('.btn').trigger('click')
    end
    within "#decision-branch-item-#{decision_branches.first.id}" do
      find('.btn-secondary').trigger('click')
    end
    find("#alert-delete-button").click
    page.save_screenshot
    within '.master-detail-panel__master' do
      expect(page).to_not have_content(decision_branches.first.body)
    end
  end
end
