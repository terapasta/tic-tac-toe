class LineCredentialSerializer < ActiveModel::Serializer
  attributes :channel_id, :channel_secret, :channel_access_token
end