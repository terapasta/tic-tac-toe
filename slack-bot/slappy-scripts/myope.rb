get_bot_id

hello do
  puts 'successfly connected'
end

hear '(.*)' do |e|
  Slappy.logger.info e.data.to_json
  if reply_to_me?(e)
    e.reply "#{e.user.name} やあやあ" + Bot.first.name
  end
end
