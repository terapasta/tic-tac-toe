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

  desc 'Calc bad count summaries in last 30 days'
  task calc_bad_counts_last_30_days: :environment do
    ActiveRecord::Base.transaction do
      Bot.all.each do |bot|
        30.times do |n|
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

  task calc_bad_counts_in: :environment do
    target_date = ENV['TARGET_DATE']
    ActiveRecord::Base.transaction do
      Bot.all.each do |bot|
        sum = BadCountSummarizer.new(bot)
        data = sum.get_between(
          start_time: Time.zone.parse("#{target_date} 00:00:00"),
          end_time: Time.zone.parse("#{target_date} 23:59:59")
        )
        next unless data.count.zero?
        sum.summarize(date: Time.zone.parse(target_date))
        record = sum.build
        record.created_at = Time.zone.parse(target_date)
        record.save!
      end
    end
  end
end