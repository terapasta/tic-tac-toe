Bot.seed(:id,
  { id: 1, user_id: 1, name: 'どんうさぎbot(社内slack用)', start_answer_id: 1, token: SecureRandom.hex(32) },
  { id: 2, user_id: 1, name: 'ハナコ（ヘルプデスクbot）', token: SecureRandom.hex(32) },
  { id: 3, user_id: 1, name: 'ヘヤ子さん', token: SecureRandom.hex(32) },
)
