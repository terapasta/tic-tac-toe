module MlHelper
  def file_import(bot, filename, mime_type = 'text/csv')
    file = fixture_file_upload(filename, mime_type)
    raise 'file import failed' unless QuestionAnswer.import_csv(file, bot)
    LearnJob.new.perform(bot.id)
  end

  def add_tag_to_question_answer(bot, body, tags)
    question_answer = bot.question_answers.find_by!(question: body)
    question_answer.update(tag_list: tags)
  end
end
