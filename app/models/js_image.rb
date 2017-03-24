class JsImage < ActiveHash::Base
  fields :name, :url

  %w(
    silhouette.png
  ).each do |image_name|
    create \
      name: image_name,
      url: ActionController::Base.helpers.asset_path(image_name)
  end

  class << self
    def to_named_map
      all.inject({}) { |res, d|
        res[d.name] = d.url
        res
      }
    end
  end
end
