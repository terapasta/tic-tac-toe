class AddSelectableQuestion < ActiveRecord::Migration
  def change
    add_column :bots, :is_selected_for_chat, :boolean, default: false
    add_column :bots, :selected_question_answer_ids, :text
  end
end
