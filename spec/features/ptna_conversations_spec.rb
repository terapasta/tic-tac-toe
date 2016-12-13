require 'rails_helper'

feature 'PTNAのデータで意図した通りにBotとの対話が出来る' do
  let(:chat) { @bot.chats.create!(guest_key: 'random-hogehoge-moge') }
  let(:conversation_bot) { Conversation::Bot.new(@bot, message) }

  before(:all) do
    learning_parameter = build(:learning_parameter, algorithm: :logistic_regression, classify_threshold: 0.5)
    @bot = create(:bot, learning_parameter: learning_parameter)
    file_import(@bot, 'ptna.csv')
    learn(@bot)
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

  context '「入会したいのですが」とポストされた場合' do
    let(:message) { chat.messages.build(speaker: 'guest', body: '入会したいのですが') }
    scenario do
      expect(subject[0].body).to be_include "オンライン入会\r\nhttps://www.piano.or.jp/member_entry/member_entry_step0_1.php\r\n\r\n入会申込書のご請求\r\nhttp://www.piano.or.jp/info/member/memberentry.html"
    end
  end
end
