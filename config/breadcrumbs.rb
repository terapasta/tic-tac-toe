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

crumb :bot_question_answers do |bot|
  link 'Q&A', bot_question_answers_path(bot)
end

crumb :edit_bot_question_answer do |bot, question_answer|
  link '編集', edit_bot_question_answer_path(bot, question_answer)
  parent :bot_question_answers, bot
end

crumb :new_bot_question_answer do |bot|
  link '新規登録', new_bot_question_answer_path(bot)
  parent :bot_question_answers, bot
end
