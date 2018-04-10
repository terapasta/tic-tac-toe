class CreateInitialSelections < ActiveRecord::Migration[5.1]
  class TempBot < ActiveRecord::Base
    self.table_name = 'bots'
    serialize :selected_question_answer_ids, Array
  end

  class TempQuestionAnswer < ActiveRecord::Base
    self.table_name = 'question_answers'
  end

  class TempInitialSelection < ActiveRecord::Base
    self.table_name = 'initial_selections'
  end

  def self.up
    create_table :initial_selections do |t|
      t.integer :bot_id, null: false
      t.integer :question_answer_id, null: false
      t.integer :position, null: false, default: 0

      t.timestamps
      t.index [:bot_id, :question_answer_id], unique: true
    end

    ActiveRecord::Base.transaction do
      TempBot.all.each do |bot|
        ids = bot.selected_question_answer_ids || []
        p ids
        TempQuestionAnswer.where(bot_id: bot.id, id: ids).pluck(:id).each do |id|
          p TempInitialSelection.create!(bot_id: bot.id, question_answer_id: id)
        end
      end
    end
  end

  def self.down
    drop_table :initial_selections
  end
end