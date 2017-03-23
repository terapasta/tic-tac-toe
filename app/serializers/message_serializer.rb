class MessageSerializer < ActiveModel::Serializer
  attributes :id, :speaker, :rating, :created_at, :body
  has_one :answer
end
