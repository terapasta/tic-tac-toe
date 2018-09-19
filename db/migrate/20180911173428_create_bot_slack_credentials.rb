class CreateBotSlackCredentials < ActiveRecord::Migration[5.1]
  def change
    create_table :bot_slack_credentials do |t|
      t.string :team_id
      t.string :microsoft_app_id, null: false
      t.string :microsoft_app_password, null: false
      t.integer :bot_id, null: false
      t.timestamps
    end
  end
end
