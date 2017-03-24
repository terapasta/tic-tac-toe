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
      config = {
        json: collection,
        adapter: :json,
      }

      if collection.respond_to?(:current_page)
        config = config.merge(meta: api_pagination(collection))
      end

      render config.merge(options)
    end
end
