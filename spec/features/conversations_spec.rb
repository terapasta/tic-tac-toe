require 'rails_helper'

feature '意図した通りにBotとの対話が出来る' do
  let(:chat) { @bot.chats.create!(guest_key: 'random-hogehoge-moge') }
  let(:conversation_bot) { Conversation::Bot.new(@bot, message) }

  before(:all) do
    learning_parameter = build(:learning_parameter, algorithm: :naive_bayes, classify_threshold: 0.5)
    @bot = create(:bot, learning_parameter: learning_parameter)
    file_import(@bot, 'learning_training_messages.csv')
    learn(@bot)
  end

  subject { conversation_bot.reply }

  pending context '「こんにちは」とポストされた場合' do
    let(:message) { chat.messages.build(speaker: 'guest', body: 'こんにちは') }
    scenario '「こんにちは！」と返すこと' do
      expect(subject[0].body).to be_include('こんにちは！')
    end
  end
end
