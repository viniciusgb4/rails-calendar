ENV["RAILS_ENV"] ||= "test"

require 'simplecov'
SimpleCov.start

require_relative "../config/environment"
require "rails/test_help"

# Use `fetch` to fail loudly if these variables aren't set. We might relax this
# and set defaults at some point, but for the moment we want to make sure we didn't
# miss a step.
Capybara.server_host = "0.0.0.0"
Capybara.app_host = "http://#{ENV.fetch("HOSTNAME")}:#{Capybara.server_port}"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  include Devise::Test::IntegrationHelpers
  #include Warden::Test::Helpers

  def log_in(user)
    sign_in(user)
  end

end
