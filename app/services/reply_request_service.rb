class ReplyRequestService
  def initialize(bot, questions)
    @bot = bot
    @questions = questions
    @raw_questions = questions.dup
    @engine = Ml::Engine.new(@bot)
  end

  def process
    questions = @questions.map{ |q| replace_synonym_if_needed(q) }
    TimeMeasurement.measure(name: 'ReplyResponseService pythonに投げて返ってくるまで', bot: @bot) do
      @engine.replies(questions)[:data].map.with_index{ |it, i|
        ReplyResponse.new(it, @bot, questions[i], @raw_questions[i])
      }
    end
  end

  private
    def word_mappings
      @word_mappings ||= WordMapping.for_bot(@bot).decorate
    end

    def replace_synonym_if_needed(question)
      TimeMeasurement.measure(name: 'ReplyRequestService 同義語変換', bot: @bot) do
        @bot.use_similarity_classification? ?
          word_mappings.replace_synonym(question) : question
      end
    end
end