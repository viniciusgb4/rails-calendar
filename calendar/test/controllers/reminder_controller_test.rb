require "test_helper"

class ReminderControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @user.confirm
    @reminder = reminders(:one)
    @reminder.user = @user
    @reminder.save
    sign_in @user
  end

  test "should redirect to login page when user try to get new page and is not logged in" do
    sign_out @user
    get new_reminder_path
    assert_redirected_to new_user_session_path
  end

  test "should redirect to login page when user try to create a reminder and is not logged in" do
    sign_out @user
    post reminders_path, params: {reminder: {title: "Test",
                                             description: 'New test',
                                             start_datetime: '2022-06-06T08:00',
                                             end_datetime: '2022-06-06T09:00',
                                             color: 'green1'}}
    assert_redirected_to new_user_session_path
  end

  test "should redirect to login page when user try to delete a reminder and is not logged in" do
    sign_out @user
    delete reminder_path(@reminder)
    assert_redirected_to new_user_session_path
  end

  test "should get new page if user is logged in" do
    get new_reminder_path, params: {date: '2022-06-07'}, xhr: true
    assert_response :success
  end

  test "should respond with success message when we send the right parameters to CREATE a reminder" do
    post reminders_path, params: {reminder: {title: "Test",
                                  description: 'New test',
                                  start_datetime: '2022-06-06T08:00',
                                  end_datetime: '2022-06-06T09:00',
                                  color: 'green1'}}
    assert_response :success
  end

  test "should respond with a 400 (Bad Request) when we do not send the parameters to CREATE a reminder" do
    post reminders_path
    assert_response :bad_request
  end

  test "should respond with 422 message when we send a wrong parameter (title with less than 3 characters) to CREATE a reminder" do
    post reminders_path ,params: {reminder: {title: "Te",
                                            description: 'New test',
                                            start_datetime: '2022-06-07T08:00',
                                            end_datetime: '2022-06-07T09:00',
                                            color: 'green1'}}, xhr: true
    assert_response :unprocessable_entity
  end

  test "should respond with success message when we send the right parameters to UPDATE a reminder" do
    put reminder_path(@reminder),params: {reminder: {title: "Test",
                                            description: 'New test',
                                            start_datetime: '2022-06-07T08:00',
                                            end_datetime: '2022-06-07T09:00',
                                            color: 'green1'}}
    assert_response :success
  end

  test "should respond with 404 (Not Found) when we send UPDATE to a non-existing reminder" do
    put reminder_path(123456789), params: {reminder: {title: "Test",
                                                  description: 'New test',
                                                  start_datetime: '2022-06-07T08:00',
                                                  end_datetime: '2022-06-07T09:00',
                                                  color: 'green1'}}
    assert_response :not_found
  end

  test "should respond with a 400 (Bad Request) when we do not send the parameters to UPDATE a reminder" do
    put reminder_path(@reminder)
    assert_response :bad_request
  end

  test "should respond with 422 message when we send a wrong parameter (title with less than 3 characters) to UPDATE a reminder" do
    put reminder_path(@reminder),params: {reminder: {title: "Te"}}, xhr: true
    assert_response :unprocessable_entity
  end

  test "should respond with success message when we send delete an existing reminder" do
    delete reminder_path(@reminder)
    assert_response :success
  end

  test "should respond with 404 (Not Found) when we send delete to a non-existing reminder" do
    delete reminder_path(123456789)
    assert_response :not_found
  end

end
