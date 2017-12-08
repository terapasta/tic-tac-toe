class ChatworkCredentialSerializer < ActiveModel::Serializer
  attributes :api_token, :webhook_token
end