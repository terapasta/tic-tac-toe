require 'forwardable'

class Conversation::ReplyAnswer
  extend Forwardable

  def_delegators :@base, *Answer.attribute_names

  attr_accessor :probability

  def initialize(answer, probability)
    @base = answer
    @probability = probability
  end

  def answer
    @base
  end
end
