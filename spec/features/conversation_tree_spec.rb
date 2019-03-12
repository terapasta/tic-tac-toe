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
    create(:bot)
  end

  let!(:organization) do
    create(:organization, plan: :professional).tap do |org|
      org.user_memberships.create(user: user)
      org.bot_ownerships.create(bot: bot)
    end
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

  let!(:topic_tags) do
    create_list(:topic_tag, 2, bot: bot).each_with_index do |topic_tag, index|
      question_answers[index].topic_taggings.create(topic_tag: topic_tag)
    end
  end

  before do
    sign_in staff
    visit "/bots/#{bot.id}/conversation_tree"
  end

  xscenario 'display tree nodes' do
    find("#Question-#{question_answers.first.id}-link").click
    expect(page).to have_content(question_answers.first.answer)
    find("#Answer-#{question_answers.first.id}-link").click
    expect(page).to have_content(decision_branches.first.body)
    expect(page).to have_content(decision_branches.second.body)
    find("#DecisionBranch-#{decision_branches.first.id}-link").click
    expect(page).to have_content(decision_branches.first.answer)
  end

  xscenario 'search tree nodes' do
    find('input[type=search]').set(question_answers.first.answer)
    expect(page).to have_content(question_answers.first.question)
    expect(page).to have_content(question_answers.first.answer)
    expect(page).to_not have_content(question_answers.second.question)
    expect(page).to_not have_content(question_answers.second.answer)
  end

  xscenario 'creates question with answer'  do
    find('#AddQuestionAnswerButton').click
    find('[name=question-question]').set('new question')
    find('[name="question_answer[answer]"]').set('new answer')
    click_button '保存'
    within '.master-detail-panel__master' do
      expect(page).to have_content('new question')
      expect(page).to have_content('new answer')
    end
  end

  xscenario 'creates decision_branch' do
    find("#Question-#{question_answers.first.id}-link").click
    find("#Answer-#{question_answers.first.id}-link").click
    find('#AddDecisionBranchButton').click
    find('[name=decision-branch-body]').set('new decision branch')
    # fill_in_input name: 'decision-branch-body', value: 'new decision branch'
    click_button '追加'
    # find('.btn.btn-success').click
    within '.master-detail-panel__master' do
      expect(page).to have_content('new decision branch')
    end
  end

  xscenario 'updates answer' do
    find("#Question-#{question_answers.first.id}-link").click
    find("#Answer-#{question_answers.first.id}-link").click
    find('[name="question_answer[answer]"]').set('updated answer')
    # fill_in_input name: 'answer-body', value: 'updated answer'
    click_button '保存'
    within '.master-detail-panel__master' do
      expect(page).to have_content('updated answer')
    end
  end

  xscenario 'updates decision branch' do
    find("#Question-#{question_answers.first.id}-link").click
    find("#Answer-#{question_answers.first.id}-link").click
    within "#DecisionBranchItem-#{decision_branches.first.id}" do
      find('.btn').click
    end
    within "#DecisionBranchItem-#{decision_branches.first.id}" do
      find('[name=decision-branch-body]').set('updated decision branch')
      # fill_in_input name: 'decision-branch-body', value: 'updated decision branch'
      find('.btn-success').click
    end
    within '.master-detail-panel__master' do
      expect(page).to have_content('updated decision branch')
    end
  end

  xscenario 'deletes answer' do
    find("#Question-#{question_answers.first.id}-link").click
    find("#Answer-#{question_answers.first.id}-link").click
    find("#DeleteAnswerButton").click
    find(".swal2-confirm.swal2-styled").click
    within '.master-detail-panel__master' do
      expect(page).to_not have_content(question_answers.first.answer)
    end
  end

  xscenario 'deletes decision branch' do
    find("#Question-#{question_answers.first.id}-link").click
    find("#Answer-#{question_answers.first.id}-link").click
    within "#DecisionBranchItem-#{decision_branches.first.id}" do
      find('.btn').click
    end
    within "#DecisionBranchItem-#{decision_branches.first.id}" do
      find('.btn-danger').click
    end
    find(".swal2-confirm.swal2-styled").click
    within '.master-detail-panel__master' do
      expect(page).to_not have_content(decision_branches.first.body)
    end
  end

  xscenario 'order decision branches' do
    find("#Question-#{question_answers.first.id}-link").click
    find("#Answer-#{question_answers.first.id}-link").click
    expect(decision_branches.first.position).to eq(1)
    expect(decision_branches.second.position).to eq(2)
    find("#DecisionBranch-#{decision_branches.first.id}-moveLowerButton").click
    sleep 1
    expect(decision_branches.first.reload.position).to eq(2)
    expect(decision_branches.second.reload.position).to eq(1)
    find("#DecisionBranch-#{decision_branches.first.id}-moveHigherButton").click
    sleep 1
    expect(decision_branches.first.reload.position).to eq(1)
    expect(decision_branches.second.reload.position).to eq(2)
  end

  xscenario 'only show has decision branches nodes' do
    expect(page).to have_content(question_answers.first.question)
    expect(page).to_not have_content(question_answers.second.question)
    find('#toggleOnlyShowHasDecisionBranchesNode').click
    expect(page).to have_content(question_answers.first.question)
    expect(page).to have_content(question_answers.second.question)
  end

  xscenario 'filter by topic_tags' do
    find('.multiselect__tags').click
    all('.multiselect__element').detect{ |it| it.text == topic_tags.first.name }.click
    expect(page).to have_content(question_answers.first.question)
    expect(page).to_not have_content(question_answers.second.question)
  end
end
