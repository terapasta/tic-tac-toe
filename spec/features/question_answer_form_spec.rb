require 'rails_helper'

RSpec.describe 'QuestionAnswerForm', type: :feature, js: true do
  include RequestSpecHelper

  let!(:bot) do
    create(:bot, user: owner)
  end

  let!(:owner) do
    create(:user)
  end

  before do
    sign_in owner
  end

  feature 'new action' do
    before do
      visit "/bots/#{bot.id}/question_answers/new"
    end

    context 'input answer mode' do
      scenario do
        expect{
          expect{
            fill_in 'question-body', with: 'sample question'
            fill_in 'answer-body', with: 'sample answer body'
            click_button '登録'
            sleep 1
          }.to change(QuestionAnswer, :count).by(1)
        }.to change(Answer, :count).by(1)
      end
    end

    context 'select answer mode' do

    end
  end
end
