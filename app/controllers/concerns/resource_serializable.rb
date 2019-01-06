module ResourceSerializable
  extend ActiveSupport::Concern

  private
    def serialize(resource)
      ActiveModelSerializers::Adapter::Json.new(
        get_serializer(resource).serializer.new(resource)
      ).serializable_hash
    end
end