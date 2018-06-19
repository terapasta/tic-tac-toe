require 'rails_helper'

RSpec.describe 'Chats: N/A selection', type: :feature, js: true do
  let!(:bot) do
    create(:bot)
  end

  let!(:question_answers) do
    5.times do |n|
      create(:question_answer,
        id: n,
        question: "サンプル #{n}",
        bot: bot
      )
    end
  end

  let!(:learning_training_messages) do
    5.times do |n|
      create(:learning_training_message,
        id: n,
        question: "サンプル #{n}",
        question_answer_id: n,
        bot: bot
      )
    end
  end

  before do
    stub_const('Ml::Engine', DummyMLEngine)
    5.times.map{ |n|
      DummyMLEngine.add_dummy_result(
        probability: 0.7,
        question_answer_id: n,
        question: "サンプル #{n}"
      )
    }
  end

  scenario do
    visit "/embed/#{bot.token}/chats/new"
    sleep 1
    fill_in 'chat-message-body', with: 'ほげほげ'
    click_on '質問'
    sleep 1
    click_on 'どれにも該当しない'
    expect(page).to have_content(bot.classify_failed_message_with_fallback)
  end
end