class DeleteColumnsToProductionTables < ActiveRecord::Migration[5.1]
  def change
    if Rails.env.production?
      remove_column :question_answers, :question_wakati, :text
      remove_column :sub_questions, :question_wakati, :text
      remove_column :word_mapping_synonyms, :value_wakati, :string
      remove_column :word_mappings, :word_wakati, :string
    end
  end
end
