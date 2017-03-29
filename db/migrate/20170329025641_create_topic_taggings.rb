class CreateTopicTaggings < ActiveRecord::Migration
  def change
    create_table :topic_taggings do |t|
      t.integer :question_answers_id, null: false
      t.integer :topic_tags_id, null: false

      t.timestamps null: false
      t.index [:question_answers_id, :topic_tags_id], unique: true
    end
  end
end
