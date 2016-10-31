require 'rails_helper'

FOR_TEST_BOT_ID = 4

feature '意図した通りにBotとの対話が出来る' do
  let(:bot) { Bot.find(FOR_TEST_BOT_ID) }

  before do
    Learning::Summarizer.new(bot).summary
    binding.pry
    engine = Ml::Engine.new(bot.id)
    engine.learn
  end

  scenario '情報を参照できる' do
    expect(true).to be_truthy
  end
end
