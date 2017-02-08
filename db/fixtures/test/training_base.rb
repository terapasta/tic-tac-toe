Bot.seed(:id,
  { id: 3, user_id: 1, name: 'ヘヤ子さん', token: SecureRandom.hex(32) },
  { id: 4, user_id: 1, name: 'Rspec用Bot(ピティナ)', token: SecureRandom.hex(32) },
)

LearningParameter.seed(:id,
  { id: 1, bot_id: 4, include_failed_data: false }
)

Answer.seed(:id,
  { id: 1, context: 'normal', body: 'こんにちは！', headline: nil, bot_id: 4 },
  { id: 2, context: 'normal', body: 'こんばんは！', headline: nil, bot_id: 4 },
  { id: 3, context: 'normal', body: 'ありがとう！', headline: nil, bot_id: 4 },
  { id: 4, context: 'normal', body: 'すみません><', headline: nil, bot_id: 4 },
  { id: 5, context: 'normal', body: 'おやすなさい！', headline: nil, bot_id: 4 },
  { id: 6, context: 'normal', body: 'どういたしまして！', headline: nil, bot_id: 4 },
)

Answer.seed(:id,
  { id: 1001, context: 'normal', body: 'こんにちは！', headline: nil, bot_id: 3 },
)

Training.seed(:id,
  { id: 1, bot_id: 4},
  { id: 1001, bot_id: 3},
)

TrainingMessage.seed(:id,
  { id: 1001, training_id: 1001, answer_id: nil, speaker: 'guest', body: 'こんにちは' },
  { id: 1002, training_id: 1001, answer_id: 1001, speaker: 'bot', body: 'こんにちは！' },
)
