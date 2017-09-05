class AddDumpColumnsToBots < ActiveRecord::Migration
  def change
    add_column :bots, :dump_cosine_similarity, :binary, limit: 10.megabyte
    add_column :bots, :dump_logistic_regression_estimator, :binary, limit: 10.megabyte
    add_column :bots, :dump_tfidf_vectorizer, :binary, limit: 10.megabyte
    add_column :bots, :dump_normalizer, :binary, limit: 10.megabyte
    add_column :bots, :dump_lsi, :binary, limit: 10.megabyte
  end
end
