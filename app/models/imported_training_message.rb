class ImportedTrainingMessage < ActiveRecord::Base
  include HasManySentenceSynonyms

  acts_as_taggable

  belongs_to :answer
  serialize :underlayer

  validates :answer_id, presence: true

  # TODO: 戻り値を配列で返すのは一時対応なので、インポート処理を別クラスに移動していい感じにしたい
  def self.import_csv(file, bot)
    imported_training_messages = []
    current_row = nil
    open(file.path, "rb:Shift_JIS:UTF-8", undef: :replace) do |f|
      transaction do
        CSV.new(f).each_with_index do |row, index|
          current_row = index + 1
          next if row[0].blank?
          answer = bot.answers.find_or_create_by!(body: row[1])
          bot.imported_training_messages.find_or_initialize_by(question: row[0]).tap do |itm|
            itm.assign_attributes(
              answer: answer,
              underlayer: row.compact.count > 2 ? row[2..-1].compact : nil,
            )
            itm.save!
          end
        end
      end
    end
    [true]
  rescue => e
    Rails.logger.debug(e)
    Rails.logger.debug(e.backtrace.join("\n"))
    [false, current_row]
  end
end
