# DecisionBranch.seed(:id,
#   { id: 1, help_answer_id: 1, body: 'はい', next_help_answer_id: 2 },
#   { id: 2, help_answer_id: 1, body: 'いいえ', next_help_answer_id: 3 },
#   { id: 3, help_answer_id: 2, body: 'あるかもしれない。', next_help_answer_id: 4 },
#   { id: 4, help_answer_id: 2, body: '絶対ない。', next_help_answer_id: 5 },
#   { id: 5, help_answer_id: 5, body: 'はい', next_help_answer_id: 6 },
#   { id: 6, help_answer_id: 5, body: 'いいえ', next_help_answer_id: 7 },
#   { id: 7, help_answer_id: 6, body: 'はい', next_help_answer_id: 8 },
#   { id: 8, help_answer_id: 6, body: 'いいえ', next_help_answer_id: 9 },
#
#
#   # { id: 1, help_answer_id: 2, body: '社内', next_help_answer_id: 3 },
#   # { id: 2, help_answer_id: 2, body: '社外', next_help_answer_id: 4 },
#   # { id: 3, help_answer_id: 2, body: 'おぼえていない/わからない', next_help_answer_id: 4 },
#   #
#   { id: 101, help_answer_id: 102, body: '国内', next_help_answer_id: 103 },
#   { id: 102, help_answer_id: 102, body: '国外', next_help_answer_id: 107 },
#
#   { id: 103, help_answer_id: 103, body: '東北営業所', next_help_answer_id: 104 },
#   { id: 104, help_answer_id: 103, body: '関西営業所', next_help_answer_id: 105 },
#   { id: 105, help_answer_id: 103, body: '取引先', next_help_answer_id: 106 },
#
#   { id: 106, help_answer_id: 107, body: 'カリフォルニア支社', next_help_answer_id: 108 },
#   { id: 107, help_answer_id: 107, body: '取引先', next_help_answer_id: 109 },
#
#   # はい/いいえは汎用的なものなので、データではなくロジックで対処したい
#   { id: 108, help_answer_id: 101, body: 'はい', next_help_answer_id: 102 },
#   { id: 109, help_answer_id: 101, body: 'いいえ', next_help_answer_id: nil },
#
#   # { id: 110, help_answer_id: 5, body: 'はい', next_help_answer_id: 6 },
#   # { id: 111, help_answer_id: 5, body: 'いいえ', next_help_answer_id: nil },
# )
