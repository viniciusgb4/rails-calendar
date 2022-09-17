require 'system/desktop/desktop_application_system_test_case'

class CalendarDesktopTest < DesktopApplicationSystemTestCase
  def setup
    @user = users(:one)
    @user.confirm
    sign_in @user
    @year = Date.today.year
    @month = Date.today.month

    @reminder = reminders(:edit_reminder)
  end

  test "visit the calendar page" do
    visit root_path
    assert_selector "span.month", text: Date::ABBR_MONTHNAMES[@month]
    assert_selector "span", text: @year
  end

  test "create a new reminder" do
    visit root_path

    click_link "15"
    fill_in "Title", with: "Reminder Test"
    fill_in "Description", with: "Reminder Description"
    click_on "Save"

    assert_selector "div", text: "Reminder Test (08:00)"
  end

  test "edit an existing reminder" do
    visit root_path

    click_link "Edit Reminder (08:00)"
    fill_in "Title", with: "Tomorrow Test"
    fill_in "Description", with: "Reminder Description"
    click_on "Color"
    click_on "red4"
    click_on "Save"

    assert_selector "div", text: "Tomorrow Test (08:00)"
  end

  test "delete an existing reminder" do
    visit root_path

    click_link "Edit Reminder (08:00)"
    within('form') do
      click_link "Delete"
    end

    assert_no_selector "div", text: "Edit Reminder (08:00)"
  end

  test "change to next month page" do
    visit root_path

    find('a[id="next_page"]').click

    assert_selector "span.month", text: Date::ABBR_MONTHNAMES[@month + 1]
  end

  test "change to previous month page" do
    visit root_path

    find('a[id="previous_page"]').click

    assert_selector "span.month", text: Date::ABBR_MONTHNAMES[@month - 1]
  end

  test "go to today's month page" do
    visit root_path

    find('a[id="next_page"]').click
    find('a[id="next_page"]').click

    click_on "Today"

    assert_selector "span.month", text: Date::ABBR_MONTHNAMES[@month]
  end

  test "check if show more has 'more' word" do
    visit root_path

    content = page.first('tr[show-more="show_more"]').evaluate_script <<-SCRIPT
            (function () {
              var element = document.getElementsByClassName('show-more__link')[0];
              var content = window.getComputedStyle( element, ':after' ).getPropertyValue('content');
          
              return content;
             })()
    SCRIPT
    assert_equal content, '" more"'

  end

end
