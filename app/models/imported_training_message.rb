class ImportedTrainingMessage < ActiveRecord::Base
  belongs_to :answer

  def self.import_csv(file, bot)
    imported_training_messages = []
    CSV.foreach(file.path, encoding: 'Shift_JIS:UTF-8', skip_blanks: true) do |row|
      answer = bot.answers.find_or_create_by(body: row[1]) {|answer| answer.bot = bot }
      imported_training_messages << new(question: row[0], answer: answer)
    end
    import(imported_training_messages)
  end
end
