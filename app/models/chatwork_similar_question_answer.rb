class ChatworkSimilarQuestionAnswer < ApplicationRecord
  include ChatworkSelection

  belongs_to :question_answer
end
