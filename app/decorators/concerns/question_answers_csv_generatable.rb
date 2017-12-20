module QuestionAnswersCsvGeneratable
  extend ActiveSupport::Concern

  include CsvGeneratable

  def to_csv(encoding: :utf8)
    headers = [:id, :topic_tags, :question, :answer].map{|x| I18n.t("question_answer.csv_headers.#{x}") }
    super(encoding: encoding.to_sym, header_columns: headers) do |csv, item|
      csv << [
        item.id,
        item.topic_tags.map(&:name).join('/').presence,
        item.question,
        item.answer,
      ]
    end
  end
end
