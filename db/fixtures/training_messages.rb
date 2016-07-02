TrainingMessage.seed(:id,
  # 最初の学習のエラー回避のためのダミーデータ
  { id: 1, training_id: 1, answer_id: 1, speaker: 'bot', body: 'こんにちは' },
  { id: 2, training_id: 1, answer_id: nil, speaker: 'guest', body: 'こんにちは' },
  { id: 3, training_id: 1, answer_id: 2, speaker: 'bot', body: 'こんにちは' },
  { id: 4, training_id: 1, answer_id: nil, speaker: 'guest', body: 'こんにちは' },
  { id: 5, training_id: 1, answer_id: 3, speaker: 'bot', body: 'こんにちは' },
  { id: 6, training_id: 1, answer_id: nil, speaker: 'guest', body: 'こんにちは' },
)
