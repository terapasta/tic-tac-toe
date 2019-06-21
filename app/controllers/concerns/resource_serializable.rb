module ResourceSerializable
  extend ActiveSupport::Concern

  private
    def serialize(resource, options = {})
      ActiveModelSerializers::Adapter::Json.new(
        get_serializer(resource).serializer.new(resource)
      ).serializable_hash(options)
    end
end