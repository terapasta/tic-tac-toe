class DeleteIncludeXxxColumnsFromLearningParameters < ActiveRecord::Migration[4.2]
  def up
    remove_column :learning_parameters, :include_failed_data
    remove_column :learning_parameters, :include_tag_vector
  end

  def down
    add_column :learning_parameters, :include_failed_data, :boolean, default: false, null: false
    add_column :learning_parameters, :include_tag_vector, :boolean, default: false, null: false
  end
end
