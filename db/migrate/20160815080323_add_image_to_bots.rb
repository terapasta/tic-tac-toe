class AddImageToBots < ActiveRecord::Migration
  def change
    add_column :bots, :image, :string, before: :created_at
  end
end
