# frozen_string_literal: true
module API
  module PaginationHelpers
    extend Grape::API::Helpers

    def kaminari_params(collection, extra_meta = {})
      {
        current_page: collection.current_page,
        next_page: collection.next_page,
        prev_page: collection.prev_page,
        total_pages: collection.total_pages,
        total_count: collection.total_count,
      }.merge(extra_meta)
    end

    def serialized_paginated_results(results, serializer, options = {})
      collection = results.page(options[:page]).per(options[:per])
      struct = Struct.new(:current_user)
      scope = struct.new(current_user)
      serialized = ActiveModel::Serializer::CollectionSerializer.new(
        collection,
        serializer: serializer,
        scope: scope,
      )
      extra_meta = options.except(:page)
      render items: serialized, meta: kaminari_params(collection, extra_meta)
    end
  end
end
