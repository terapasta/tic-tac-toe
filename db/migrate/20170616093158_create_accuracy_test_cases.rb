class CreateAccuracyTestCases < ActiveRecord::Migration
  def change
    create_table :accuracy_test_cases do |t|
      t.text :question_text
      t.text :expected_text
      t.boolean :is_expected_suggestion, default: false
      t.integer :bot_id, null: false

      t.timestamps null: false
    end
  end
end
