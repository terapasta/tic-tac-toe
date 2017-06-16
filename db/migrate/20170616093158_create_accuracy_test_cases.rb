class CreateAccuracyTestCases < ActiveRecord::Migration
  def change
    create_table :accuracy_test_cases do |t|
      t.text :question_text
      t.text :expected_text
      t.boolean :is_expected_suggest, default: false
      t.belongs_to :bot, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
