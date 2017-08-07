Bot.seed(:id,
  { id: 3, user_id: 1, name: 'ヘヤ子さん', token: SecureRandom.hex(32) },
  { id: 4, user_id: 1, name: 'Rspec用Bot(ピティナ)', token: SecureRandom.hex(32) },
)

LearningParameter.seed(:id,
  { id: 1, bot_id: 4, use_similarity_classification: true }
)
