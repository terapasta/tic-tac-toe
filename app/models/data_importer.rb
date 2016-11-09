# FIXME メンテ工数を減らすために一旦使わない
require 'kconv'

class DataImporter
  def self.import(file, bot)
    csv_text = file.read
    csv_table = CSV.parse(Kconv.toutf8(csv_text))
    headers = csv_table[0]

    csv_table.each_with_index do |row, index|
      next if index == 0
      name = row[0]

      headers.each_with_index do |header, in_index|
        next if in_index == 0
        question = "#{name} #{header}"
        answer_body = "#{name}の#{header}は#{row[in_index]}です。"

        # FIXME トランザクションを1回にしたい
        answer = bot.answers.create!(body: answer_body)
        training = bot.trainings.create!
        training.training_messages.create!(body: question, speaker: 'guest')
        training.training_messages.create!(body: answer.body, answer_id: answer.id, speaker: 'bot')
      end
    end
  end
end
