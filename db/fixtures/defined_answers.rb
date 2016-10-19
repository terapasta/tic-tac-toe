# TODO defined_answerはbotに関係なく共通にしたい
DefinedAnswer.seed(:defined_answer_id,
  { defined_answer_id: 1, bot_id: 1, context: 'normal', body: '開始メッセージが未設定です。Bot編集画面から設定してください。' },
  { defined_answer_id: 2, bot_id: 1, context: 'normal', body: '回答出来ませんでした。この回答失敗時のメッセージはBot編集画面から変更できます。' },
  { defined_answer_id: 3, bot_id: 2, context: 'normal', body: '開始メッセージが未設定です。Bot編集画面から設定してください。' },
  { defined_answer_id: 4, bot_id: 2, context: 'normal', body: '回答出来ませんでした。この回答失敗時のメッセージはBot編集画面から変更できます。' },
)
