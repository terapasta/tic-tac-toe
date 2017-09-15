require 'json'
include ReplyTestable

def session
  { states: {} }
end

helper = SlackBotHelper.new

hello do
  puts 'successfly connected'
end

respond '正答率' do |e|
  begin
    Slappy.logger.info e.data.to_json
    e.reply_to(e.user, 'はい！各ボットの正答率です！', {
      attachments: helper.generate_attachments(all_bot_accuracy_test!),
    })
  rescue => e
    Slappy.logger.error e.message
    e.reply_to(e.user, "エラーしたみたいです `#{e.message}`")
  end
end

respond '.*' do |e|
  Slappy.logger.info e.data.to_json
  begin
    next if e.data['text'].include?('正答率')
    bot = Bot.first
    chat = bot.chats.find_or_create_by(guest_key: Slappy.configuration.token + Time.zone.now.strftime('%Y-%m-%d'))

    if chat.messages.count.zero?
      chat.build_start_message
      chat.save!
    end

    ActiveRecord::Base.transaction do
      message = chat.messages.create!(
        body: e.data['text'].gsub(/<@[A-Z0-9]+>/, ''),
        speaker: 'guest',
        user_agent: 'slack',
      )
      messages = receive_and_reply!(chat, message)
      text = messages.map(&:body).join("\n")
      e.reply_to(e.user, text) if text.present?
    end
  rescue => e
    Slappy.logger.error e.message + e.backtrace.join("\n")
    e.reply_to(e.user, "エラーしたみたいです `#{e.message}`")
  end
end

# 毎週月曜10am
schedule '0 10 * * 1' do |e|
  send_all_bot_accuracies(helper.generate_attachments(all_bot_accuracy_test!))
end

# 毎週水曜10am
schedule '0 10 * * 3' do |e|
  send_all_bot_accuracies(helper.generate_attachments(all_bot_accuracy_test!))
end

def send_all_bot_accuracies(attachments)
  begin
    Slappy.logger.info '正答率を定期投稿します'
    Slappy::Messenger.new({
      text: '定期投稿です。 各ボットの正答率',
      channel: '#random',
      attachments: attachments,
    }).message
  rescue => e
    Slappy.logger.error e.message + e.backtrace.join("\n")
    e.reply_to(e.user, "エラーしたみたいです `#{e.message}`")
  end
end
