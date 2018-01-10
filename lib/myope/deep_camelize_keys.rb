module DeepCamelizeKeys
  def self.deep_camelize_keys(hash)
    {}.tap do |h|
      hash.each { |key, value| h[key.to_s.camelize(:lower)] = DeepCamelizeKeys.map_value(value) }
    end
  end

  def self.map_value(thing)
    case thing
    when Hash
      DeepCamelizeKeys.deep_camelize_keys(thing)
    when Array
      thing.map { |v| DeepCamelizeKeys.map_value(v) }
    else
      thing
    end
  end

  def deep_camelize_keys(hash)
    DeepCamelizeKeys.deep_camelize_keys(hash)
  end
end
