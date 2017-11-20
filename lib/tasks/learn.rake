namespace :learn do
  task tag: :environment do
    engine = Ml::Engine.new(nil)
    engine.learn_tag_model
  end
end
