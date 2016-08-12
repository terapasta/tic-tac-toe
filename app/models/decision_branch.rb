class DecisionBranch < ActiveRecord::Base
  belongs_to :help_answer
  belongs_to :next_help_answer
end
