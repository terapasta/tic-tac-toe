namespace :data_summary do
  desc 'Calc bad count data summaries in today'
  task calc_bad_counts: :environment do
    ActiveRecord::Base.transaction do
      Bot.all.each do |bot|
        summarizer = BadCountSummarizer.new(bot)
        summarizer.summarize
        summarizer.save!
      end
    end
  end

  desc 'Calc bad count summaries in last 7 days'
  task calc_bad_counts_last_7_days: :environment do
    ActiveRecord::Base.transaction do
      Bot.all.each do |bot|
        7.times do |n|
          date = n.days.ago.end_of_day
          summarizer = BadCountSummarizer.new(bot)
          summarizer.summarize(date: date)
          record = summarizer.build
          record.created_at = date
          record.save!
        end
      end
    end
  end
end