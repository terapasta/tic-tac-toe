class ReplyRequestService
  def initialize(bot, questions)
    @bot = bot
    @questions = questions
    @raw_questions = questions.dup
    @engine = Ml::Engine.new(@bot)
  end

  def process
    # NOTE:
    # 単語の normalize処理は python側にまとめる
    # https://www.pivotaltracker.com/n/projects/1879711/stories/158060539

    TimeMeasurement.measure(name: 'ReplyResponseService pythonに投げて返ってくるまで', bot: @bot) do
      @engine.replies(@questions)[:data].map.with_index{ |it, i|
        ReplyResponse.new(it, @bot, @questions[i], @raw_questions[i])
      }
    end
  end

end