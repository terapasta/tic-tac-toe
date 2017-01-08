module MlHelper
  def file_import(bot, filename, mime_type = 'text/csv')
    file = fixture_file_upload(filename, mime_type)
    raise 'file import failed' unless ImportedTrainingMessage.import_csv(file, bot)
    LearnJob.new.perform(bot.id)
  end

  def learn_tag_model
    engine = Ml::Engine.new(nil)
    engine.learn_tag_model
  end

  def add_tag_to_imported_training_message(bot, body, tags)
    imported_training_message = bot.imported_training_messages.find_by!(question: body)
    imported_training_message.update(tag_list: tags)
  end
end
