class HelpAnswer < ActiveRecord::Base
  belongs_to :bot
  has_many :decision_branches
end
