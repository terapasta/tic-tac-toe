class JsImage
  Images = %w(
    silhouette.png
  )

  class << self
    def all
      Images.map{ |image_name|
        {
          name: image_name,
          url: ActionController::Base.helpers.asset_path(image_name)
        }
      }
    end

    def to_named_map
      all.inject({}) { |res, d|
        res[d[:name]] = d[:url]
        res
      }
    end
  end
end
