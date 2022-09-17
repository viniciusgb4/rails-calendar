require "test_helper"

class DeleteReminderFlowTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @user.confirm
    @reminder = reminders(:deleted)
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

  test "can delete a reminder" do
    get edit_reminder_path(@reminder)
    assert_response :success

    assert_difference("Reminder.count", -1) do
      delete reminder_path(@reminder)
      assert_response :success

      get root_path
      assert_select 'tr[reminder-row=true] div[title="Deleted Reminder (2022-07-01 08:00 - 2022-07-01 09:00)"]', false
    end
  end

end
