class AddUuidToAnswerInlineImages < ActiveRecord::Migration[5.1]
  def change
    add_column :answer_inline_images, :uuid, :string, null: false
  end
end
