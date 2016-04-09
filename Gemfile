source 'https://rubygems.org'
ruby '2.3.0'

gem 'rails', '4.2.6'
gem 'spring', :group => :development
gem 'bullet', :group => :development

gem 'rails-api'       # Rails for API only applications
gem 'pg'              # database for Active Record
gem 'grape'           # REST-like API micro-framework for Ruby
gem 'devise'          # authentication
gem 'roar'            # Ruby representer
gem 'grape-entity'    # Grape representer
gem 'counter_culture' # turbo-charged counter caches
gem 'kaminari'        # pagination
gem 'api-pagination'
gem 'http_accept_language' # extracts Accept-Language header into an array
gem 'rack-cors', :require => 'rack/cors' # support for Cross-Origin Resource Sharing (CORS)
gem 'figaro'      # app configuration using ENV and a single YAML file
gem 'carrierwave' # file upload library for Ruby
gem 'fog'         # Ruby cloud services library (used in carrierwave to send images to AWS S3)
gem 'mini_magick' # handle picture resizing

group :development do
  gem 'pry-rails' # changes rails console to 'pry'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'database_cleaner'
end

group :production do
  gem 'rollbar', git: 'git://github.com/rollbar/rollbar-gem.git'
  gem 'oj', '~> 2.12.14'
end
