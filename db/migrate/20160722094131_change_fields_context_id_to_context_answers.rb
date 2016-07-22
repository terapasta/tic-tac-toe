class ChangeFieldsContextIdToContextAnswers < ActiveRecord::Migration
  def change
    rename_column :answers, :context_id, :context
    change_column :answers, :context, :string, default: 'normal', null: false
  end
end
