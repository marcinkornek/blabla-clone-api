# frozen_string_literal: true

module API
  module ParamsHelper
    extend Grape::API::Helpers

    params :pagination_params do |options = {}|
      optional :page, type: Integer, default: options.fetch(:page_default, 1),
                      desc: "Page number of search results"
      optional :per, type: Integer, default: options.fetch(:per_default, 25),
                     desc: "Number of records per page for search results"
    end
  end
end
