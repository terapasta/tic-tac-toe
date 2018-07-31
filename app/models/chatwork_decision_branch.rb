class ChatworkDecisionBranch < ApplicationRecord
  include ChatworkSelection

  belongs_to :decision_branch
end
