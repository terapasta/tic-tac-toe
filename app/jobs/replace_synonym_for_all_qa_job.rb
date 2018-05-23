class ReplaceSynonymForAllQaJob < ApplicationJob
  def perform(bot_id = nil)
    QuestionAnswer.replace_synonym_all!(bot_id)
  end
end