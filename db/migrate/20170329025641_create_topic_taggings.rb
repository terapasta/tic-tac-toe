class CreateTopicTaggings < ActiveRecord::Migration
  def change
    create_table :topic_taggings do |t|
      t.integer :question_answer_id, null: false
      t.integer :topic_tag_id, null: false

      t.timestamps null: false
      t.index [:question_answer_id, :topic_tag_id], unique: true
    end
  end
end
