class AddIsShowInSuggestionToTopicTags < ActiveRecord::Migration[5.1]
  def change
    add_column :topic_tags, :is_show_in_suggestion, :boolean, default: true
  end
end
