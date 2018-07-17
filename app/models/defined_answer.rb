class DefinedAnswer
  def self.start_answer_unsetting_text
    '開始メッセージが未設定です。ボット設定画面から設定してください。'
  end

  def self.classify_failed_text
    "回答が見つかりませんでした。もう少し詳しい内容を入力していただけますか？\n\nもし回答が見つからない場合は、 example@my-ope.net 宛にご質問いただければ、後ほど担当者からメール致します。\n\nこの回答不可時のメッセージはボット設定画面から変更できます。"
  end
end
