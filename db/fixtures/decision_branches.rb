DecisionBranch.seed(:id,
  { id: 1, help_answer_id: 2, body: '社内', next_help_answer_id: 3 },
  { id: 2, help_answer_id: 2, body: '社外', next_help_answer_id: 4 },
  { id: 3, help_answer_id: 2, body: 'おぼえていない/わからない', next_help_answer_id: 4 },

  { id: 4, help_answer_id: 5, body: '国内', next_help_answer_id: 6 },
  { id: 5, help_answer_id: 5, body: '国外', next_help_answer_id: 10 },

  { id: 6, help_answer_id: 6, body: '東北営業所', next_help_answer_id: 7 },
  { id: 7, help_answer_id: 6, body: '関西営業所', next_help_answer_id: 8 },
  { id: 8, help_answer_id: 6, body: '取引先', next_help_answer_id: 9 },

  { id: 9, help_answer_id: 10, body: 'カリフォルニア支社', next_help_answer_id: 11 },
  { id: 10, help_answer_id: 10, body: '取引先', next_help_answer_id: 12 },
)
