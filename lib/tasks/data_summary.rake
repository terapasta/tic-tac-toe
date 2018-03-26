namespace :data_summary do
  desc 'Calc all data summaries'
  task calc_all: :environment do
    ActiveRecord::Base.transaction do
      Bot.all.each do |bot|
        summarizer = BadCountSummarizer.new(bot)
        summarizer.summarize
        summarizer.save!
      end
    end
  end
end