class ApplicationDecorator < Draper::Decorator
  def as_json(options = nil)
    object.as_json(options).transform_keys{ |key| key.to_s.camelize(:lower) }
  end

  def errors_as_json
    object.errors.full_messages.to_json
  end
end
