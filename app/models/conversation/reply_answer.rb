class Conversation::ReplyAnswer
  attr_accessor :answer, :probability

  def initialize(answer, probability)
    @answer = answer
    @probability = probability
  end
end
