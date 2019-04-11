class RatingSerializer < ActiveModel::Serializer
  attributes :id, :level, :message_id
end