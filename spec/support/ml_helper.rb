module MlHelper
  def file_import(bot, filename, mime_type = 'text/csv')
    file = fixture_file_upload(filename, mime_type)
    raise 'file import failed' unless ImportedTrainingMessage.import_csv(file, bot)
    Learning::Summarizer.summary_all
    LearningTrainingMessage.amp!(bot)
    engine = Ml::Engine.new(bot)
    engine.learn
  end
end
