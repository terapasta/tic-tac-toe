class AddPinCodeToBots < ActiveRecord::Migration[5.1]
  def change
    add_column :bots, :pin_code, :string
  end
end
