class IncludeFailedDataDefaultFalse < ActiveRecord::Migration
  def change
    change_column :learning_parameters, :include_failed_data, :boolean, default: false
  end
end
