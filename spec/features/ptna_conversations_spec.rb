require 'rails_helper'

feature 'PTNAのデータで意図した通りにBotとの対話が出来る' do
  let(:chat) { @bot.chats.create!(guest_key: 'random-hogehoge-moge') }
  let(:conversation_bot) { Conversation::Bot.new(@bot, message) }

  before(:all) do
    @bot = create(:bot)
    file_import(@bot, 'ptna.csv')
  end

  subject { conversation_bot.reply }

  context '「こんにちは」とポストされた場合' do
    let(:message) { chat.messages.build(speaker: 'guest', body: 'こんにちは') }
    scenario '「こんにちは」と返すこと' do
      expect(subject[0].body).to eq 'こんにちは'
    end
  end

  context '「こんにちは」とポストされた場合' do
    let(:message) { chat.messages.build(speaker: 'guest', body: 'こんにちは') }
    scenario '「こんにちは」と返すこと' do
      expect(subject[0].body).to eq 'こんにちは'
    end
  end

  # context '「おいしいラーメンが食べたいです」とポストされた場合' do
  #   let(:message) { chat.messages.build(speaker: 'guest', body: 'おいしいラーメンが食べたいです') }
  #   scenario '回答失敗を返すこと' do
  #     expect(subject[0].body).to be_include('回答できませんでした。質問文面を変えて再度ご入力ください。')
  #   end
  # end
end
