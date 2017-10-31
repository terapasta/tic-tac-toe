class ChangeBodyFieldsLimit < ActiveRecord::Migration[4.2]
  def change
    change_column :learning_training_messages, :answer_body, :text, limit: 10000
    change_column :messages, :body, :text, limit: 10000
    change_column :training_messages, :body, :text, limit: 10000
  end
end
