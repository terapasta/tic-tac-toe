class CreateSentenceSynonyms < ActiveRecord::Migration[4.2]
  def change
    create_table :sentence_synonyms do |t|
      t.references :training_message, index: true, null: false
      t.references :created_user, index: true, null: false
      t.text :body, null: false

      t.timestamps null: false
    end
  end
end
