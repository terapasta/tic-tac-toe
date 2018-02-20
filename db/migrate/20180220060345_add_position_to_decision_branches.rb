class AddPositionToDecisionBranches < ActiveRecord::Migration[5.1]
  class TempQuestionAnswer < ActiveRecord::Base
    self.table_name = 'question_answers'
    has_many :decision_branches, foreign_key: :question_answer_id
  end

  class TempDecisionBranch < ActiveRecord::Base
    self.table_name = 'decision_branches'

    has_many :child_decision_branches,
      class_name: 'TempDecisionBranch',
      foreign_key: :parent_decision_branch_id
  end

  def set_position_to!(decision_branch, index)
    decision_branch.position = index + 1
    decision_branch.save!
    decision_branch.child_decision_branches.each_with_index do |db, i|
      set_position_to!(db, i)
    end
  end

  def change
    add_column :decision_branches, :position, :integer

    ActiveRecord::Base.transaction do
      TempQuestionAnswer.all.each do |tqa|
        tqa.decision_branches.each_with_index do |db, i|
          set_position_to!(db, i)
        end
      end
    end
  end
end
