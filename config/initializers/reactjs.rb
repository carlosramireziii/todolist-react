Rails.application.configure do
  config.react.variant  = Rails.env.production? ? :production : :development
  config.react.addons   = true
end