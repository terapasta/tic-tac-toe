class Conversation::Reply
  attr_accessor :question, :question_feature_count, :answer, :probability

  def initialize(attributes)
    attributes.each do | key, value |
      public_send("#{key}=", value) if respond_to?("#{key}=")
    end
  end
end
