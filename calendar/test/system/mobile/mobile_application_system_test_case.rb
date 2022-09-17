require "test_helper"

class MobileApplicationSystemTestCase < ActionDispatch::SystemTestCase
  WINDOW_SIZE = [360, 600].freeze

  driven_by :selenium, using: :chrome, screen_size: WINDOW_SIZE, options: {
    browser: :remote,
    url: "http://chrome-server:4444"
  }

  setup do
    Capybara.current_session.current_window.resize_to(*WINDOW_SIZE)
  end

end