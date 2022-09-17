require "test_helper"

class CalendarControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @user.confirm
    sign_in @user
  end

  teardown do
    # Do nothing
  end

  test "should get index" do
    get root_path
    assert_response :success
    assert_equal "text/html", @response.media_type
  end

  test "should get current month" do
    get today_path, xhr: true
    assert_response :success
    assert_equal "text/vnd.turbo-stream.html", @response.media_type
  end

  test "should get next month page" do
    get next_page_path, xhr: true
    assert_response :success
    assert_equal "text/vnd.turbo-stream.html", @response.media_type
  end

  test "should get previous month page" do
    get previous_page_path, xhr: true
    assert_response :success
    assert_equal "text/vnd.turbo-stream.html", @response.media_type
  end

  test "should get today month page" do
    get today_path, xhr: true
    assert_response :success
    assert_equal "text/vnd.turbo-stream.html", @response.media_type
  end

end
