class CreateDecisionBranches < ActiveRecord::Migration
  def change
    create_table :decision_branches do |t|
      t.references :help_answer, index: true
      t.string :body, null: false
      t.references :next_help_answer, index: true

      t.timestamps null: false
    end
  end
end
