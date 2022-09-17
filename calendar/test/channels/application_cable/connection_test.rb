require "test_helper"

class ApplicationCable::ConnectionTest < ActionCable::Connection::TestCase

  test "check if connect is working" do
    connect
    assert_not_nil connection
  end

end
