class TopicTagsDecorator < Draper::CollectionDecorator
  def as_repo_json
    object.inject({}) { |acc, topic_tag|
      acc[topic_tag.id] = TopicTagSerializer.new(topic_tag).as_json
      acc
    }
  end
end