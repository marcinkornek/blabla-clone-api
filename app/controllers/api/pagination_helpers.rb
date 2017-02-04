# frozen_string_literal: true
module API
  module PaginationHelpers
    extend Grape::API::Helpers

    def kaminari_params(collection)
      {
        current_page: collection.current_page,
        next_page: collection.next_page,
        prev_page: collection.prev_page,
        total_pages: collection.total_pages,
        total_count: collection.total_count,
      }
    end

    def paginated_results(results, page, per = 25)
      return { collection: results, meta: {} } if page.nil?

      collection = results.page(page).per(per)
      {
        collection: collection,
        meta: kaminari_params(collection),
      }
    end
  end
end
