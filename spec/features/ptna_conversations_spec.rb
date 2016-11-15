require 'rails_helper'

feature 'PTNAのデータで意図した通りにBotとの対話が出来る' do
  let(:bot) { create(:bot) }
  let(:chat) { bot.chats.create!(guest_key: 'random-hogehoge-moge') }
  let(:conversation_bot) { Conversation::Bot.new(bot, message) }

  before do
    file_import(bot, 'ptna.csv')
  end

  subject { conversation_bot.reply }

  context '「こんにちは」とポストされた場合' do
    let(:message) { chat.messages.build(speaker: 'guest', body: 'こんにちは') }
    scenario '「こんにちは」と返すこと' do
      expect(subject[0].body).to eq 'こんにちは'
    end
  end

  # context '「サンキュー」とポストされた場合' do
  #   let(:message) { chat.messages.build(speaker: 'guest', body: 'サンキュー') }
  #   scenario '「どういたしまして！」と返すこと' do
  #     expect(subject[0].body).to be_include('どういたしまして！')
  #   end
  # end
end
