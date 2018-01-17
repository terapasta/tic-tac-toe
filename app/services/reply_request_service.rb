class ReplyRequestService
  def initialize(bot, questions)
    @bot = bot
    @questions = questions
    @engine = Ml::Engine.new(@bot)
  end

  def process
    questions = @questions.map{ |q| replace_synonym_if_needed(q) }
    @engine.replies(questions)[:data].map.with_index{ |it, i|
      ReplyResponse.new(it, @bot, questions[i])
    }
  end

  private
    def word_mappings
      @word_mappings ||= WordMapping.for_bot(@bot).decorate
    end

    def replace_synonym_if_needed(question)
      @bot.use_similarity_classification? ?
        word_mappings.replace_synonym(question) : question
    end
end