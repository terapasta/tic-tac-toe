class DeleteServicesTable < ActiveRecord::Migration
  def change
    drop_table :services
  end
end
