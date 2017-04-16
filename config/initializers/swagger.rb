# frozen_string_literal: true

GrapeSwaggerRails.options.app_name = "Blabla-clone API"
GrapeSwaggerRails.options.url = "/api/swagger_doc"
GrapeSwaggerRails.options.before_action do
  GrapeSwaggerRails.options.app_url = request.protocol + request.host_with_port
end
