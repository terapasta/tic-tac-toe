class AddEnableGuestUserRegistrationToBots < ActiveRecord::Migration
  def change
    add_column :bots, :enable_guest_user_registration, :boolean, default: false
  end
end
