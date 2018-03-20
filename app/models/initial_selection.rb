class InitialSelection < ApplicationRecord
  belongs_to :bot
  belongs_to :question_answer

  acts_as_list scope: [:bot_id]
end
