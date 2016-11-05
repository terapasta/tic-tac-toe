require 'rails_helper'

FOR_TEST_BOT_ID = 4

feature '意図した通りにBotとの対話が出来る' do
  let(:bot) { Bot.find(FOR_TEST_BOT_ID) }
  let(:chat) { bot.chats.create!(guest_key: 'random-hogehoge-moge') }

  before do
    # 事前に画面から学習させておくためコメントアウト
    Learning::Summarizer.new(bot).summary
    engine = Ml::Engine.new(bot.id)
    engine.learn
  end

  context '「こんにちは」とポストされた場合' do
    let(:message) { chat.messages.build(speaker: 'guest', body: 'こんにちは') }
    scenario do
      conversation_bot = Conversation::Bot.new(bot, message)
      expect(conversation_bot.reply[0].body).to be_include('こんにちは！')
    end
  end
  
  #
  # context '「ピティナってなに」とポストされた場合' do
  #   let(:message) { chat.messages.build(speaker: 'guest', body: 'ピティナってなに') }
  #   scenario do
  #     conversation_bot = Conversation::Bot.new(bot, message)
  #     expect(conversation_bot.reply[0].body).to be_include('ピティナ（一般社団法人全日本ピアノ指導者協会）は、')
  #     # expect(conversation_bot.other_answers.map(&:headline)).to be_include('ピティナ申込にあたる料金について')
  #   end
  # end
  #
  # context '「ピティナとは」とポストされた場合' do
  #   let(:message) { chat.messages.build(speaker: 'guest', body: 'ピティナとは') }
  #   scenario do
  #     conversation_bot = Conversation::Bot.new(bot, message)
  #     expect(conversation_bot.reply[0].body).to be_include('ピティナ（一般社団法人全日本ピアノ指導者協会）は、')
  #   end
  # end
end
