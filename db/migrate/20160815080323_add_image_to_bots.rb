class AddImageToBots < ActiveRecord::Migration[4.2]
  def change
    add_column :bots, :image, :string, before: :created_at
  end
end
