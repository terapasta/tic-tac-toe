require 'rails_helper'

FOR_TEST_BOT_ID = 4

feature '意図した通りにBotとの対話が出来る' do
  let(:bot) { Bot.find(FOR_TEST_BOT_ID) }
  let(:chat) { bot.chats.create!(guest_key: 'random-hogehoge-moge') }
  let(:conversation_bot) { Conversation::Bot.new(bot, message) }

  before do
    Learning::Summarizer.new(bot).summary
    LearningTrainingMessage.amp!(bot)
    engine = Ml::Engine.new(bot)
    engine.learn
  end

  subject { conversation_bot.reply }

  context '「こんにちは」とポストされた場合' do
    let(:message) { chat.messages.build(speaker: 'guest', body: 'こんにちは') }
    scenario '「こんにちは！」と返すこと' do
      expect(subject[0].body).to be_include('こんにちは！')
    end
  end

  context '「サンキュー」とポストされた場合' do
    let(:message) { chat.messages.build(speaker: 'guest', body: 'サンキュー') }
    scenario '「どういたしまして！」と返すこと' do
      expect(subject[0].body).to be_include('どういたしまして！')
    end
  end
end
