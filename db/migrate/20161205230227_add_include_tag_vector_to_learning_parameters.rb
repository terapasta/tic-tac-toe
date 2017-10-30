class AddIncludeTagVectorToLearningParameters < ActiveRecord::Migration[4.2]
  def change
    add_column :learning_parameters, :include_tag_vector, :boolean, after: :include_failed_data, null: false, default: false
  end
end
