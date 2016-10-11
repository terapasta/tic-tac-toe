class ImportedTrainingMessage < ActiveRecord::Base
  belongs_to :answer

  def self.import_csv(file, bot)
    bot.imported_training_messages.destroy_all

    imported_training_messages = []
    CSV.foreach(file.path, encoding: 'Shift_JIS:UTF-8', skip_blanks: true) do |row|
      answer = bot.answers.find_or_initialize_by(body: row[1]) {|answer| answer.bot = bot }
      imported_training_message = bot.imported_training_messages.build(question: row[0], answer: answer)
      imported_training_message.underlayer = row[2..-1].compact if row.compact.count > 2
      imported_training_message.save!
    end
    true
  rescue => e
    Rails.logger.debug(e)
    Rails.logger.debug(e.backtrace.join("\n"))
    false
  end
end
