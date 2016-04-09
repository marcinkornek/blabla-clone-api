if Rails.env.production?
  Rollbar.configure do |config|
    config.access_token = '987fca994b2e41a1b68d9f12e709f5b9'
    config.enabled = false if Rails.env.test? || Rails.env.development?
    config.environment = ENV['ROLLBAR_ENV'] || Rails.env
  end
end
