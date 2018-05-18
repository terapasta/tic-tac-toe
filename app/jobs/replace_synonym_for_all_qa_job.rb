class ReplaceSynonymForAllQaJob < ApplicationJob
  def perform
    bots = Bot.all
    bot_word_mappings = bots.inject({}) { |acc, bot|
      acc[bot.id] = WordMapping.for_bot(bot).decorate
      acc
    }

    ActiveRecord::Base.transaction do
      bots.each do |bot|
        word_mappings = bot_word_mappings[bot.id]
        bot.question_answers.each do |qa|
          qa.question_wakati = word_mappings.replace_synonym(Wakatifier.apply(qa.question))
          qa.save!(validate: false)
          puts "#{qa.id}: #{qa.question_wakati}"

          qa.sub_questions.each do |sq|
            sq.question_wakati = word_mappings.replace_synonym(Wakatifier.apply(sq.question))
            sq.save!(validate: false)
            puts "    #{sq.id}: #{sq.question_wakati}"
          end

        end
      end
    end
  end
end