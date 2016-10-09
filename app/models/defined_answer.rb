class DefinedAnswer < Answer
  START_ANSWER_UNSETTING_ID = 1

  def self.start_answer_unsetting
    find_by(defined_answer_id: START_ANSWER_UNSETTING_ID)
  end
end
