require 'rails_helper'

RSpec.describe 'AnswerInlintImage', feature: true, js: true do
  let!(:bot) do
    create(:bot)
  end

  let!(:user) do
    create(:user)
  end

  let!(:organization) do
    create(:organization).tap do |org|
      org.user_memberships.create(user: user)
      org.bot_ownerships.create(bot: bot)
    end
  end

  let!(:question_answer) do
    create(:question_answer, bot: bot)
  end

  let!(:decision_branch) do
    create(:decision_branch, bot: bot, question_answer: question_answer)
  end

  let!(:answer_inline_image) do
    create(:answer_inline_image, bot: bot)
  end

  let(:last_answer_inline_image) do
    AnswerInlineImage.last
  end

  let(:sample_image) do
    Rails.root.join('spec/fixtures/images/sample_naoki.jpg')
  end

  before do
    stub_const('Ml::Engine', DummyMLEngine)
    login_as user
  end

  feature 'insert image on edit question answer page' do
    scenario do
      visit "/bots/#{bot.id}/question_answers/#{question_answer.id}/edit"
      attach_file 'answer-inline-image', sample_image, make_visible: true
      sleep 1
      expect(find('[name="question_answer[answer]"]').value).to be_include(last_answer_inline_image.file_url)
      click_on '更新する'
      expect(page).to have_content('更新しました')
      expect(find('[name="question_answer[answer]"]').value).to be_include(last_answer_inline_image.file_url)
    end
  end

  feature 'insert image on conversation tree page' do
    context 'when question answer form' do
      scenario do
        visit "/bots/#{bot.id}/conversation_tree"
        click_on question_answer.question
        attach_file 'answer-inline-image', sample_image, make_visible: true
        sleep 1
        expect(find('[name="question_answer[answer]"]').value).to be_include(last_answer_inline_image.file_url)
        click_on '保存'
        sleep 1
        expect(question_answer.reload.answer).to be_include(last_answer_inline_image.file_url)
      end
    end

    context 'when answer form' do
      scenario do
        visit "/bots/#{bot.id}/conversation_tree"
        click_on question_answer.question
        click_on question_answer.answer
        attach_file 'answer-inline-image', sample_image, make_visible: true
        sleep 1
        expect(find('[name="question_answer[answer]"]').value).to be_include(last_answer_inline_image.file_url)
        click_on '保存'
        sleep 1
        expect(question_answer.reload.answer).to be_include(last_answer_inline_image.file_url)
      end
    end

    context 'when decision branch form' do
      scenario do
        visit "/bots/#{bot.id}/conversation_tree"
        click_on question_answer.question
        click_on question_answer.answer
        click_on decision_branch.body
        attach_file 'answer-inline-image', sample_image, make_visible: true
        sleep 1
        expect(find('[name="question_answer[answer]"]').value).to be_include(last_answer_inline_image.file_url)
        click_on '保存'
        sleep 1
        expect(decision_branch.reload.answer).to be_include(last_answer_inline_image.file_url)
      end
    end
  end

  feature 'showing up' do
    before do
      question_answer.update(answer: "![hogehoge](#{answer_inline_image.file_url})")
    end

    feature 'showing up answer inline image on question answer index page' do
      scenario do
        visit "/bots/#{bot.id}/question_answers"
        expect(find("img[src='#{answer_inline_image.file_url}']")).to be_present
      end
    end

    feature 'showing up answer inline image on chat' do
      before do
        DummyMLEngine.add_dummy_result(probability: 1, question_answer_id: question_answer.id)
      end

      scenario do
        visit "/embed/#{bot.token}/chats/new"
        fill_in 'chat-message-body', with: 'sample question'
        within 'form' do
          click_on '質問'
        end
        expect(find("img[src='#{answer_inline_image.file_url}']")).to be_present
      end
    end

    feature 'showing up answer inline image on chat history' do
      before do
        bot.chats.create(guest_key: 'hogehoge').tap do |chat|
          chat.messages.create(speaker: :bot, body: 'first', created_at: 3.seconds.ago)
          chat.messages.create(speaker: :guest, body: 'second', created_at: 2.seconds.ago)
          chat.messages.create(speaker: :bot,
            question_answer: question_answer,
            body: "![hogehoge](#{answer_inline_image.file_url})"
          )
        end
      end

      scenario do
        visit "/bots/#{bot.id}/threads"
        expect(find("img[src='#{answer_inline_image.file_url}']")).to be_present
      end
    end
  end
end
