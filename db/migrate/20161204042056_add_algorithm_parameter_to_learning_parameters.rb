class AddAlgorithmParameterToLearningParameters < ActiveRecord::Migration[4.2]
  def change
    add_column :learning_parameters, :algorithm, :integer, after: :bot_id, null: false, default: 0
    add_column :learning_parameters, :params_for_algorithm, :text, after: :algorithm
  end
end
