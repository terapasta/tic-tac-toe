class AddPasswordToBots < ActiveRecord::Migration[5.1]
  def change
    add_column :bots, :password, :string
  end
end
