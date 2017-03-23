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
        meta: api_pagination(collection),
        adapter: :json,
      }

      render config.merge(options)
    end
end
