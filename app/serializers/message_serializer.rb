class MessageSerializer < ActiveModel::Serializer
  attributes :id, :speaker, :rating, :created_at
  has_one :answer
end
