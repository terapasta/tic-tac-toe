require 'forwardable'

class Conversation::ReplyAnswer
  extend Forwardable

  def_delegators :@base, *Answer.instance_methods

  attr_accessor :probability

  def initialize(answer, probability)
    @base = answer
    @probability = probability
  end

  def answer
    @base
  end
end
