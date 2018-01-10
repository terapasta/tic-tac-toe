class CreateAnswerLinks < ActiveRecord::Migration[5.1]
  def change
    create_table :answer_links do |t|
      t.integer :decision_branch_id, null: false
      t.integer :answer_record_id, null: false
      t.string :answer_record_type, null: false

      t.timestamps
      t.index [:decision_branch_id, :answer_record_id, :answer_record_type], unique: true, name: :answer_links_main_index
    end
  end
end
