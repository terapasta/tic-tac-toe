class AddEnableGuestUserRegistrationToBots < ActiveRecord::Migration[4.2]
  def change
    add_column :bots, :enable_guest_user_registration, :boolean, default: false
  end
end
