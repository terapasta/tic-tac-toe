class ChangeFieldBotIdAllowNullAnswers < ActiveRecord::Migration[4.2]
  def change
    change_column :answers, :bot_id, :integer, null: true
  end
end
