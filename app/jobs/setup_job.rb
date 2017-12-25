class SetupJob < ApplicationJob
  def perform
    engine = Ml::Engine.new(nil)
    engine.setup
  end
end
