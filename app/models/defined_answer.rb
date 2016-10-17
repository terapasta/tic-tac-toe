class DefinedAnswer < Answer
  START_ANSWER_UNSETTING_ID = 1
  CLASSIFY_FAILED_ID = 2

  def self.start_answer_unsetting
    find_by(defined_answer_id: START_ANSWER_UNSETTING_ID)
  end

  def self.classify_failed
    find_by(defined_answer_id: CLASSIFY_FAILED_ID)
  end
end
