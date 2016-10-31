class ChangeFieldBotIdAllowNullAnswers < ActiveRecord::Migration
  def change
    change_column :answers, :bot_id, :integer, null: true
  end
end
