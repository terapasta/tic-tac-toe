class ChangeSentenceSynonymsTrainingMessageIdToNullTrue < ActiveRecord::Migration[4.2]
  def change
    change_column :sentence_synonyms, :training_message_id, :integer, null: true
  end
end
