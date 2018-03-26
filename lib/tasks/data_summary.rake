namespace :data_summary do
  desc 'Calc all data summaries'
  task calc_all: :environment do
    ActiveRecord::Base.transaction do
      Bot.pluck(:id).each do |bot_id|
        summarizer = BadCountSummarizer.new(bot_id)
        summarizer.summarize
        summarizer.save!
      end
    end
  end
end