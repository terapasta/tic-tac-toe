class DeleteServicesTable < ActiveRecord::Migration[4.2]
  def change
    drop_table :services
  end
end
