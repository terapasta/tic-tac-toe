namespace :ml_engine do
  desc 'ml engineを初期化する'
  task setup: :environment do
    engine = Ml::Engine.new(nil)
    engine.setup
  end
end
