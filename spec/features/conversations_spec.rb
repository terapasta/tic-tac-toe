require 'rails_helper'

feature '意図した通りにBotとの対話が出来る' do
  let(:bot) { create(:bot) }
  let(:chat) { bot.chats.create!(guest_key: 'random-hogehoge-moge') }
  let(:conversation_bot) { Conversation::Bot.new(bot, message) }

  before do
    file = fixture_file_upload('learning_training_messages.csv', 'text/csv')
    ImportedTrainingMessage.import_csv(file, bot)
    Learning::Summarizer.summary_all
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

  # context '「サンキュー」とポストされた場合' do
  #   let(:message) { chat.messages.build(speaker: 'guest', body: 'サンキュー') }
  #   scenario '「どういたしまして！」と返すこと' do
  #     expect(subject[0].body).to be_include('どういたしまして！')
  #   end
  # end
end
