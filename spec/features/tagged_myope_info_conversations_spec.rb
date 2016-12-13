require 'rails_helper'

feature 'My-ope紹介Botのデータで意図した通りにBotとの対話が出来る(タグ付き)' do
  # let(:chat) { @bot.chats.create!(guest_key: 'random-hogehoge-myope-info') }
  # let(:conversation_bot) { Conversation::Bot.new(@bot, message) }
  #
  # before(:all) do
  #   learn_tag_model
  #   learning_parameter = build(:learning_parameter, include_tag_vector: true, algorithm: :naive_bayes, classify_threshold: 0.5)
  #   @bot = create(:bot, learning_parameter: learning_parameter)
  #   file_import(@bot, 'myope_info.csv')
  #
  #   add_tag_to_imported_training_message(@bot, 'セキュリティは万全なの？', %w(セキュリティ 質問))
  #
  #   learn(@bot)
  # end
  #
  # subject { conversation_bot.reply }
  #
  # context '「セキュリティはどう？」とポストされた場合' do
  #   let(:message) { chat.messages.build(speaker: 'guest', body: 'セキュリティはどう？') }
  #   scenario do
  #     expect(subject[0].body).to be_include 'セキュリティ対策については、ファイアウォールやSSL接続などの一般的な対策は行っております。'
  #   end
  # end
  #
  # pending context '「セキュリティーはどうなっている？」とポストされた場合' do
  #   let(:message) { chat.messages.build(speaker: 'guest', body: 'セキュリティーはどうなっている？') }
  #   scenario do
  #     expect(subject[0].body).to be_include 'セキュリティ対策については、ファイアウォールやSSL接続などの一般的な対策は行っております。'
  #   end
  # end
end
