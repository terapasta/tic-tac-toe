module DeepCamelizeKeys
  def deep_camelize_keys(hash)
     {}.tap do |h|
       hash.each { |key, value| h[key.to_s.camelize(:lower)] = map_value(value) }
     end
   end

   def map_value(thing)
     case thing
     when Hash
       deep_camelize_keys(thing)
     when Array
       thing.map { |v| map_value(v) }
     else
       thing
     end
   end
end
