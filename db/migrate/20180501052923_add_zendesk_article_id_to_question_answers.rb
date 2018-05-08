class AddZendeskArticleIdToQuestionAnswers < ActiveRecord::Migration[5.1]
  def change
    add_column :question_answers, :zendesk_article_id, :integer, limit: 8
  end
end
