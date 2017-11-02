class AddWidgetSubtitleToBots < ActiveRecord::Migration[5.1]
  def change
    add_column :bots, :widget_subtitle, :string
  end
end
