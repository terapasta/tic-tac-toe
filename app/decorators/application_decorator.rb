class ApplicationDecorator < Draper::Decorator
  include DeepCamelizeKeys

  def as_json(options = nil)
    deep_camelize_keys(object.as_json(options))
  end

  def errors_as_json
    object.errors.full_messages.to_json
  end
end
