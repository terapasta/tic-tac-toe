class AddIncludeTagVectorToLearningParameters < ActiveRecord::Migration
  def change
    add_column :learning_parameters, :include_tag_vector, :boolean, after: :include_failed_data, null: false, default: false
  end
end
