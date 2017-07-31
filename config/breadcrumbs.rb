crumb :dashboard do |bot|
  link 'ダッシュボード', bot_path(bot)
end

crumb :bot_threads do |bot|
  link '対話履歴', bot_threads_path(bot)
end

crumb :bot_thread_messages do |bot, chat|
  link '対話履歴詳細', bot_thread_messages_path(bot, chat)
  parent :bot_threads, bot
end
