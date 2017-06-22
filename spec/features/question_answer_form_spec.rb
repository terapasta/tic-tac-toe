require 'rails_helper'

RSpec.describe 'QuestionAnswerForm', type: :feature, js: true do
  include RequestSpecHelper

  let!(:bot) do
    create(:bot, user: owner)
  end

  let!(:owner) do
    create(:user)
  end

  let!(:question_answer) do
    bot.question_answers.create(attributes_for(:question_answer))
  end

  let!(:answer) do
    bot.answers.create(attributes_for(:answer)).tap do |a|
      question_answer.update(answer: a)
    end
  end

  before do
    sign_in owner
  end

  feature 'new action' do
    subject do
      lambda do
        visit "/bots/#{bot.id}/question_answers/new"
        fill_in 'question_answer[question]', with: 'sample question'
        fill_in 'question_answer[answer_attributes][body]', with: 'sample answer body'
        click_button '登録する'
      end
    end

    it { is_expected.to change(QuestionAnswer, :count).by(1) }
    it { is_expected.to change(Answer, :count).by(1) }
  end

  feature 'edit action' do
    subject do
      lambda do
        visit "/bots/#{bot.id}/question_answers/#{question_answer.id}/edit"
        fill_in 'question_answer[question]', with: 'update question'
        fill_in 'question_answer[answer_attributes][body]', with: 'update answer'
        click_button '更新する'
        question_answer.reload
        answer.reload
      end
    end

    it { is_expected.to change(question_answer, :question).to('update question') }
    it { is_expected.not_to change(answer, :body) }
    it { is_expected.not_to change(QuestionAnswer, :count) }
    it { is_expected.to change(Answer, :count).by(1) }
  end
end
