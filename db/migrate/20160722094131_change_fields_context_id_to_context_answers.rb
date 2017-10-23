class ChangeFieldsContextIdToContextAnswers < ActiveRecord::Migration[4.2]
  def change
    rename_column :answers, :context_id, :context
    change_column :answers, :context, :string, default: 'normal', null: false
  end
end
