# frozen_string_literal: true
source "https://rubygems.org"
ruby "2.3.1"

gem "rails"
gem "spring", group: :development
gem "bullet", group: :development

gem "redis"           # in-memory data structure store
gem "puma"            # Action Cable needs a threaded server
gem "pg"              # database for Active Record
gem "grape"           # REST-like API micro-framework for Ruby
gem "hashie-forbidden_attributes" # disables the security feature of strong_params at
# the model layer, allowing you the use of Grape's own params
# validation instead.
gem "devise"          # authentication
gem "geocoder"
gem "grape-entity"    # Grape representer
gem "active_model_serializers"
gem "counter_culture" # turbo-charged counter caches
gem "kaminari" # pagination
gem "kaminari-grape"
gem "api-pagination"
gem "http_accept_language" # extracts Accept-Language header into an array
gem "rack-cors", require: "rack/cors" # support for Cross-Origin Resource Sharing (CORS)
gem "figaro"      # app configuration using ENV and a single YAML file
gem "carrierwave" # file upload library for Ruby
gem "fog"         # Ruby cloud services library (used in carrierwave to send images to AWS S3)
gem "mini_magick" # handle picture resizing
gem "pundit"

group :development do
  gem "pry-rails" # changes rails console to 'pry'
  gem "rubocop"
end

group :development, :test do
  gem "rspec-rails"
  gem "database_cleaner"
  gem "factory_girl_rails"
  gem "faker", github: "stympy/faker"
end

group :production do
  gem "rollbar", git: "git://github.com/rollbar/rollbar-gem.git"
  gem "oj", "~> 2.12.14"
end
