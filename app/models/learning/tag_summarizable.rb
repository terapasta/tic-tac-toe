module Learning::TagSummarizable
  def merge_tag_ids!(learning_training_messages)
    questions = learning_training_messages.map(&:question)
    engine = Ml::Engine.new(nil)
    result = engine.predict_tags(questions)
    Rails.logger.debug(result['tags'])
    learning_training_messages.zip(result['tags']).each do |learning_training_message, tag|
      if learning_training_message.tag_ids.blank?
        learning_training_message.tag_ids = tag.join(':')
      end
    end
  end

  # private_class_method :merge_tag_ids!
end
