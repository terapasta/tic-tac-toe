Bot.seed(:id,
  { id: 3, user_id: 1, name: 'ヘヤ子さん', token: SecureRandom.hex(32) },
  { id: 4, user_id: 1, name: 'Rspec用Bot(ピティナ)', token: SecureRandom.hex(32) },
)

LearningParameter.seed(:id,
  { id: 1, bot_id: 4, include_failed_data: false }
)

Answer.seed(:id,
  { id: 1, context: 'normal', body: 'こんにちは！', bot_id: 4 },
  { id: 2, context: 'normal', body: 'こんばんは！', bot_id: 4 },
  { id: 3, context: 'normal', body: 'ありがとう！', bot_id: 4 },
  { id: 4, context: 'normal', body: 'すみません><', bot_id: 4 },
  { id: 5, context: 'normal', body: 'おやすなさい！', bot_id: 4 },
  { id: 6, context: 'normal', body: 'どういたしまして！', bot_id: 4 },
)

Answer.seed(:id,
  { id: 1001, context: 'normal', body: 'こんにちは！', bot_id: 3 },
)
