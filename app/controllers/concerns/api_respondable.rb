module ApiRespondable
  extend ActiveSupport::Concern

  private
    def api_pagination(collection)
      {
        current_page: collection.current_page,
        next_page: collection.next_page,
        total_pages: collection.total_pages,
        total_count: collection.total_count
      }
    end

    def render_collection_json(collection, options = {})
      is_reverse = options.delete(:reverse)
      config = {}

      if collection.respond_to?(:current_page)
        config.merge!(meta: api_pagination(collection))
      end

      config.merge!(
        json: is_reverse ? collection.reverse : collection,
        adapter: :json,
      )

      render config.merge(options)
    end
end
