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

  context '「おいしいラーメンが食べたいです」とポストされた場合' do
    let(:message) { chat.messages.build(speaker: 'guest', body: 'おいしいラーメンが食べたいです') }
    scenario '回答失敗を返すこと' do
      expect(subject[0].body).to eq '回答出来ませんでした。この回答失敗時のメッセージはBot編集画面から変更できます。'
    end
  end

  pending context '「当日の予定を知りたい」とポストされた場合' do
    let(:message) { chat.messages.build(speaker: 'guest', body: '当日の予定を知りたい') }
    scenario do
      expect(subject[0].body).to be_include '当日の時間割の発表は、全ての地区で公平を保つため一律で参加票の発送、'
    end
  end
end
