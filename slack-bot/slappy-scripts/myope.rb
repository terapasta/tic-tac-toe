require 'json'

helper = SlackBotHelper.new

hello do
  puts 'successfly connected'
end

respond '正答率' do |e|
  Slappy.logger.info e.data.to_json
  e.reply_to(e.user, 'はい！各ボットの正答率です！', {
    attachments: helper.bot_scores_as_attachment,
  })
end

# 毎週月曜10am
schedule '0 10 * * 1' do |e|
  helper.send_bot_scores('定期投稿です。')
end

# 毎週水曜10am
schedule '0 10 * * 3' do |e|
  helper.send_bot_scores('定期投稿です。')
end
