class AddColumnQuestionAnswerIdToSentenceSynonyms < ActiveRecord::Migration
  def up
    add_column :sentence_synonyms, :question_answer_id, :integer
    
    add_index :sentence_synonyms, :question_answer_id

    sentence_synonyms = SentenceSynonym.all
    sentence_synonyms.each do |ss|
      ss.question_answer_id = ss.training_message_id
      ss.save
    end
  end

  def down
    remove_column :sentence_synonyms, :question_answer_id
    remove_index :sentence_synonyms, :question_answer_id
  end
end
