namespace :daikin do
  desc 'ダイキンの想定外質問テスト'
  task unexpected_question_test: :environment do
    file_path = Rails.root.join('tmp/daikin-unexpected-question-test.csv')
    fail 'Not found csv' unless file_path.exist?

    bot = Bot.where('name LIKE ?', '%ダイキン%').first
    fail 'Not found bot' if bot.nil?

    data = CSV.parse(file_path.read)

    result = CSV.generate(force_quotes: true, row_sep: "\r\n") { |out|
      data.each do |row|
        message = Struct.new(:body, :class).new(row.first, 'test')
        responder = Conversation::Bot.new(bot, message)
        answers = responder.reply.map(&:body)
        puts answers
        out << row + answers
      end
    }

    result_path = Rails.root.join("tmp/daikin-unexpected-question-test-result-#{Time.current.strftime('%Y%m%d%H%M')}.csv")
    result_file = File.open(result_path, 'w')
    result_file.write(result)
  end
end
