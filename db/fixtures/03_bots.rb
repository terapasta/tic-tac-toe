Bot.seed(:id,
  { id: 1, user_id: 1, name: 'どんうさぎbot(社内slack用)', token: SecureRandom.hex(32), is_demo: false },
  { id: 2, user_id: 1, name: 'ハナコ（ヘルプデスクbot）', token: SecureRandom.hex(32), is_demo: false },
  { id: 3, user_id: 1, name: 'ヘヤ子さん', token: SecureRandom.hex(32), is_demo: false },
)
