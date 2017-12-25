namespace :ml_engine do
  desc 'ml engineを初期化する'
  task setup: :environment do
    SetupJob.perform_later
  end
end
