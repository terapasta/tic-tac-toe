require 'rails_helper'

feature 'My-ope紹介Botのデータで意図した通りにBotとの対話が出来る' do
  let(:chat) { @bot.chats.create!(guest_key: 'random-hogehoge-myope-info') }
  let(:conversation_bot) { Conversation::Bot.new(@bot, message) }

  before(:all) do
    learning_parameter = build(:learning_parameter, algorithm: :naive_bayes, classify_threshold: 0.5)
    @bot = create(:bot, learning_parameter: learning_parameter)
    file_import(@bot, 'myope_info.csv')
    learn(@bot)
  end

  subject { conversation_bot.reply }

  context '「セキュリティはどう？」とポストされた場合' do
    let(:message) { chat.messages.build(speaker: 'guest', body: 'セキュリティはどう？') }
    scenario do
      expect(subject[0].body).to be_include 'セキュリティ対策については、ファイアウォールやSSL接続などの一般的な対策は行っております。'
    end
  end

  context '「セキュリティーはどうなっている？」とポストされた場合' do
    let(:message) { chat.messages.build(speaker: 'guest', body: 'セキュリティーはどうなっている？') }
    scenario do
      expect(subject[0].body).to be_include 'セキュリティ対策については、ファイアウォールやSSL接続などの一般的な対策は行っております。'
    end
  end

  context '「どんな会社が使ってる？」とポストされた場合' do
    let(:message) { chat.messages.build(speaker: 'guest', body: 'どんな会社が使ってる？') }
    scenario do
      expect(subject[0].body).to be_include 'ユーザー企業は追々公開していきますが、とある社団法人さんや上場企業さんなど、'
    end
  end

  context '「何歳ですか？」とポストされた場合' do
    let(:message) { chat.messages.build(speaker: 'guest', body: '何歳ですか') }
    scenario '回答失敗を返すこと' do
      expect(subject[0].body).to eq '回答出来ませんでした。この回答失敗時のメッセージはBot編集画面から変更できます。'
    end
  end

  # TODO 「使ってる」に反応してしまう誤答。TFIDFなどで正しく分類されるようにしたい
  pending context 'サーバーはどこ使ってるの' do
    let(:message) { chat.messages.build(speaker: 'guest', body: 'サーバーはどこ使ってるの') }
    scenario do
      expect(subject[0].body).to eq 'インフラは実績も多くセキュリティ評価も高いAmazon Web Services(AWS)のサーバを使っております。高可用性で安定しているので安心です♪'
    end
  end

  # TODO
  pending context '「ECサイトでも使えますか？」とポストされた場合' do
    let(:message) { chat.messages.build(speaker: 'guest', body: 'ECサイトでも使えますか？') }
    scenario do
      expect(subject[0].body).to be_include '個別の商品に関する質問にお答えすることは難しいですが'
    end
  end

  # TODO
  pending context '「どんな質問ならいける？」とポストされた場合' do
    let(:message) { chat.messages.build(speaker: 'guest', body: 'どんな質問ならいける？') }
    scenario do
      expect(subject[0].body).to be_include '学習用に投入したデータによりますが、WEBサイトなどによく掲載されている'
    end
  end

  # TODO
  pending context '「クラウドサービスですか？」とポストされた場合' do
    let(:message) { chat.messages.build(speaker: 'guest', body: 'クラウドサービスですか？') }
    scenario do
      expect(subject[0].body).to be_include 'はい、My-ope officeはクラウドサービスです。'
    end
  end
end
