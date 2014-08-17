UnturnedServers::Application.configure do
  config.cache_classes = false

  config.eager_load = false
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  config.active_support.deprecation = :log

  config.assets.debug = true

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = { :host => "localhost" }
  config.action_mailer.smtp_settings = {
    address: "smtp.gmail.com",
    port: 587,
    domain: "localhost:3000",
    authentication: "plain",
    enable_starttls_auto: true,
    user_name: ENV["GMAIL_USERNAME"],
    password: ENV["GMAIL_PASSWORD"]
  }
end
