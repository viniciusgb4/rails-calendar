require "test_helper"

class EditReminderFlowTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @user.confirm
    @reminder = reminders(:one)
    @reminder.user = @user
    @reminder.save
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

  test "can edit a reminder" do
    get edit_reminder_path(@reminder)
    assert_response :success

    put reminder_path(@reminder),params: {reminder: {title: "Edited",
                                                     description: 'New test',
                                                     start_datetime: '2022-07-07T08:00',
                                                     end_datetime: '2022-07-07T09:00',
                                                     color: 'green1'}}
    assert_response :success

    get root_path
    assert_select 'tr[reminder-row=true] span', 'Edited (08:00)'
  end

end
