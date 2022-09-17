require "test_helper"

class ChangePageFlowTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @user.confirm
    sign_in @user
    cookies[:year] = 2022
    cookies[:month] = 7
  end

  test "can see calendar page" do
    get root_path
    assert_select "span.month", "Jul"
    assert_select "tbody#calendar-body" do
      assert_select "tr[id=?]", 'week-2022-06-26'
      assert_select "tr[id=?]", 'week-2022-07-03'
      assert_select "tr[id=?]", 'week-2022-07-10'
      assert_select "tr[id=?]", 'week-2022-07-17'
      assert_select "tr[id=?]", 'week-2022-07-24'
      assert_select "tr[id=?]", 'week-2022-07-31'
    end
  end

  test "can go to the next month page" do
    get next_page_path, xhr: true
    assert_response :success
    get root_path
    assert_select "span.month", "Aug"
    assert_select "tbody#calendar-body" do
      assert_select "tr[id=?]", 'week-2022-07-31'
      assert_select "tr[id=?]", 'week-2022-08-07'
      assert_select "tr[id=?]", 'week-2022-08-14'
      assert_select "tr[id=?]", 'week-2022-08-21'
      assert_select "tr[id=?]", 'week-2022-08-28'
      assert_select "tr[id=?]", 'week-2022-09-04'
    end

  end

  test "can go to the previous month page" do
    get previous_page_path, xhr: true
    assert_response :success
    get root_path
    assert_select "span.month", "Jun"
    assert_select "tbody#calendar-body" do
      assert_select "tr[id=?]", 'week-2022-05-29'
      assert_select "tr[id=?]", 'week-2022-06-05'
      assert_select "tr[id=?]", 'week-2022-06-12'
      assert_select "tr[id=?]", 'week-2022-06-19'
      assert_select "tr[id=?]", 'week-2022-06-26'
      assert_select "tr[id=?]", 'week-2022-07-03'
    end
  end

end
