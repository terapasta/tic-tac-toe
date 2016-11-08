Bot.seed(:id,
  { id: 4, user_id: 1, name: 'Rspec用Bot(ピティナ)', token: SecureRandom.hex(32) },
)

Answer.seed(:id,
  { id: 1, context: 'normal', body: 'こんにちは！', headline: nil, bot_id: 4 },
  { id: 2, context: 'normal', body: 'こんばんは！', headline: nil, bot_id: 4 },
  { id: 3, context: 'normal', body: 'ありがとう！', headline: nil, bot_id: 4 },
  { id: 4, context: 'normal', body: 'すみません><', headline: nil, bot_id: 4 },
  { id: 5, context: 'normal', body: 'おやすなさい！', headline: nil, bot_id: 4 },
  { id: 5, context: 'normal', body: 'おやすなさい！', headline: nil, bot_id: 4 },
)

WordMapping.seed(:id,
  { id: 1, word: 'こんにちは', synonym: 'こんにちわ' },
  # { id: 1, word: 'こんにちは', synonym: 'こんちゃ' },
)

Training.seed(:id,
  { id: 1, bot_id: 4},
)

TrainingMessage.seed(:id,
  { id: 1, training_id: 1, answer_id: nil, speaker: 'guest', body: 'こんにちは' },
  { id: 2, training_id: 1, answer_id: 1, speaker: 'bot', body: 'こんにちは！' },
  { id: 3, training_id: 1, answer_id: nil, speaker: 'guest', body: 'こんばんは' },
  { id: 4, training_id: 1, answer_id: 2, speaker: 'bot', body: 'こんばんは！' },
  { id: 5, training_id: 1, answer_id: nil, speaker: 'guest', body: '便利だね！' },
  { id: 6, training_id: 1, answer_id: 3, speaker: 'bot', body: 'ありがとう！' },
  { id: 7, training_id: 1, answer_id: nil, speaker: 'guest', body: 'あまり使えないね' },
  { id: 8, training_id: 1, answer_id: 4, speaker: 'bot', body: 'すみません><' },
  { id: 9, training_id: 1, answer_id: nil, speaker: 'guest', body: 'おやすみー' },
  { id: 10, training_id: 1, answer_id: 5, speaker: 'bot', body: 'おやすみなさい' },
)
