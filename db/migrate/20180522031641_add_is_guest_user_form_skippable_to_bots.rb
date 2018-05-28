class AddIsGuestUserFormSkippableToBots < ActiveRecord::Migration[5.1]
  def change
    add_column :bots, :is_guest_user_form_skippable, :boolean, default: true, null: false
  end
end
