require 'json'
include Replyable

def session
  { states: {} }
end

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

respond '.*' do |e|
  Slappy.logger.info e.data.to_json
  bot = Bot.first
  chat = bot.chats.find_or_create_by(guest_key: Slappy.configuration.token + Time.zone.now.strftime('%Y-%m-%d'))

  if chat.messages.count.zero?
    chat.messages << chat.build_start_message
    chat.save!
  end

  message = chat.messages.build(
    body: e.data['text'].gsub(/<@[A-Z0-9]+>/, ''),
    speaker: 'guest',
    user_agent: 'slack',
  )
  messages = receive_and_reply!(chat, message)
  text = messages.map(&:body).join(",")
  e.reply_to(e.user, text) if text.present?
end

# 毎週月曜10am
schedule '0 10 * * 1' do |e|
  helper.send_bot_scores('定期投稿です。')
end

# 毎週水曜10am
schedule '0 10 * * 3' do |e|
  helper.send_bot_scores('定期投稿です。')
end
