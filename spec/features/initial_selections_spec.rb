require 'rails_helper'

RSpec.describe 'Initial Selections', type: :feature, js: true do
  let!(:bot) do
    create(:bot)
  end

  let!(:user) do
    create(:user)
  end

  let!(:organization) do
    create(:organization).tap do |org|
      org.bot_ownerships.create(bot: bot)
      org.user_memberships.create(user: user)
    end
  end

  let!(:question_answers) do
    create_list(:question_answer, 10, bot: bot)
  end

  let(:page_url) do
    "/bots/#{bot.id}/question_answers/selections"
  end

  before do
    login_as(user, scope: :user)
  end

  feature 'visit and see index page' do
    scenario do
      visit page_url
      expect(page).to have_content('まだ選択されているQ&Aはありません')
      question_answers.each do |qa|
        expect(page).to have_content(qa.question)
      end
    end
  end

  feature 'select questions' do
    scenario do
      visit page_url
      all('.select-link')[0].click
      expect(page).to_not have_content('まだ選択されているQ&Aはありません')
      within '.selected-list' do
        expect(page).to have_content(question_answers[0].question)
      end

      all('.select-link')[0].click
      within '.selected-list' do
        expect(page).to have_content(question_answers[1].question)
      end
      all('.select-link')[0].click
      within '.selected-list' do
        expect(page).to have_content(question_answers[2].question)
      end
      all('.select-link')[0].click
      within '.selected-list' do
        expect(page).to have_content(question_answers[3].question)
      end
      all('.select-link')[0].click
      within '.selected-list' do
        expect(page).to have_content(question_answers[4].question)
      end

      all('.select-link')[0].click
      within '.selected-list' do
        expect(page).to_not have_content(question_answers[5].question)
      end
      expect(find('.alert.alert-danger')).to_not be_nil
    end
  end

  feature 'change order of selected questions' do
    let(:selected_qas) do
      question_answers.slice(0, 3)
    end

    before do
      selected_qas.each do |qa|
        bot.initial_selections.create(question_answer: qa)
      end
    end

    scenario do
      visit page_url
      within '.selected-list' do
        expect(all('.question').map(&:text)).to eq([
          selected_qas[0].question,
          selected_qas[1].question,
          selected_qas[2].question,
        ])
        all('.move-lower').first.click
        expect(all('.question').map(&:text)).to eq([
          selected_qas[1].question,
          selected_qas[0].question,
          selected_qas[2].question,
        ])
        all('.move-higher').first.click
        expect(all('.question').map(&:text)).to eq([
          selected_qas[0].question,
          selected_qas[1].question,
          selected_qas[2].question,
        ])
      end
    end
  end
end