require 'rails_helper'

RSpec.describe 'Chats: N/A selection', type: :feature, js: true do
  let!(:bot) do
    create(:bot)
  end

  let(:dummy_results) do
    5.times.map{ |n|
      {
        "question": "サンプル #{n}",
        "probability": 0.7,
        "questionAnswerId": n
      }
    }
  end

  before do
    stub_const('Ml::Engine', DummyMLEngine)
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