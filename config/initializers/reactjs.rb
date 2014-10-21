Rails.application.configure do
  config.react.variant = Rails.env.production? ? :production : :development
end