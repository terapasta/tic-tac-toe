require 'rails_helper'

RSpec.describe 'Chats AnswerLink', type: :feature, js: true do
  let!(:user) do
    create(:user)
  end

  let!(:bot) do
    create(:bot)
  end

  let!(:organization) do
    create(:organization).tap do |org|
      org.user_memberships.create(user: user)
      org.bot_ownerships.create(bot: bot)
    end
  end

  let!(:question_answers) do
    create_list(:question_answer, 3, bot: bot)
  end

  let!(:decision_branches) do
    create_list(:decision_branch, 3, bot: bot).each_with_index do |db, i|
      db.update(question_answer: question_answers[i])
    end
  end

  before do
    login_as(user, scope: :user)
  end

  let!(:answer_links) do
    decision_branches.each_with_index do |db, i|
      case i
      when 0
        db.create_answer_link(
          answer_record_type: 'QuestionAnswer',
          answer_record_id: question_answers.second.id
        )
      when 1
        db.create_answer_link(
          answer_record_type: 'DecisionBranch',
          answer_record_id: decision_branches.third.id
        )
      end
    end
  end

  let(:new_chat_page) do
    "/embed/#{bot.token}/chats/new"
  end

  before do
    stub_const('Ml::Engine', DummyMLEngine)
  end

  feature 'Select AnswerLink' do
    before do
      DummyMLEngine.add_dummy_result(
        probability: 1.0,
        question_answer_id: question_answers.first.id
      )
    end

    scenario do
      visit new_chat_page

      find('[name=chat-message-body]').set('サンプルメッセージ')
      within 'form' do
        click_on '質問'
      end

      click_on decision_branches.first.body
      sleep 1
      expect(page).to have_content(question_answers.second.answer)

      click_on decision_branches.second.body
      sleep 1
      expect(page).to have_content(decision_branches.third.answer)
    end
  end
end