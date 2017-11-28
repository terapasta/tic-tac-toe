class Tutorial < ApplicationRecord
  belongs_to :bot

  def self.tasks
    [
      :edit_bot_profile,
      :fifty_question_answers,
      :ask_question,
      :embed_chat
    ]
  end

  def done_fifty_question_answers_if_needed!
    if (bot.question_answers.count >= 50 && !fifty_question_answers)
      self.fifty_question_answers = true
      save!
    end
  end

  def done_ask_question_if_needed!
    if !ask_question
      self.ask_question = true
      save!
    end
  end

  def done_embed_chat_if_needed!
    if !embed_chat
      self.embed_chat = true
      save!
    end
  end

  def done_embed_chat_if_needed
    done_embed_chat_if_needed!
  rescue => e
    Rails.logger.error e.message + e.backtrace.join("\n")
  end

  def done_count
    self.class.tasks.select{ |task| send(task) }.count
  end

  def tasks_count
    self.class.tasks.count
  end

  def in_the_middle?
    done_count < tasks_count
  end
end
