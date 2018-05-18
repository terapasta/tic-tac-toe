class ReplaceSynonymForAllQaJob < ApplicationJob
  def perform
    QuestionAnswer.replace_synonym_all!
  end
end