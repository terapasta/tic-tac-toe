namespace :daikin do
  desc 'ダイキンの想定外質問テスト'
  task unexpected_question_test: :environment do
    file_path = Rails.root.join('tmp/daikin-unexpected-question-test.csv')
    fail 'Not found csv' unless file_path.exist?

    bot = Bot.where('name LIKE ?', '%ダイキン%').first
    fail 'Not found bot' if bot.nil?

    data = CSV.parse(file_path.read)
    data = data.drop(1000) if Rails.env.development?

    result = CSV.generate(force_quotes: true, row_sep: "\r\n") { |out|
      data.each do |row|
        message = Struct.new(:body, :class).new(row.first, 'test')
        responder = Conversation::Bot.new(bot, message)
        answers = responder.reply
        answer_bodies = answers.map(&:body)
        puts answer_bodies
        out << [answers.detect(&:no_classified?).present? ? '✕' : '◯'] + row + answer_bodies
      end
    }

    result_path = Rails.root.join("tmp/daikin-unexpected-question-test-result-#{Time.current.strftime('%Y%m%d%H%M')}.csv")
    result_file = File.open(result_path, 'w')
    result_file.write(result)
  end
end
