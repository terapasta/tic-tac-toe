class Tutorial < ApplicationRecord
  belongs_to :bot

  def self.tasks
    [
      :edit_bot_profile,
      :fifty_question_answers,
      :ask_question,
      :embed_chat
    ]
  end
end
