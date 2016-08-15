class DecisionBranch < ActiveRecord::Base
  belongs_to :help_answer
  belongs_to :next_help_answer, class_name: 'HelpAnswer', foreign_key: :next_help_answer_id
end
