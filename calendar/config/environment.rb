# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

unless Rails.application.credentials.sendgrid.nil?
  ActionMailer::Base.smtp_settings = {
    address: 'smtp.sendgrid.net',
    port: "587",
    domain: 'heroku.com',
    user_name: 'apikey',
    password: Rails.application.credentials.sendgrid.api_key,
    authentication: 'plain',
    enable_starttls_auto: true
  }
end