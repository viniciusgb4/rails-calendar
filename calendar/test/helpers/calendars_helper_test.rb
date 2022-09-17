require 'test_helper'

class CalendarsHelperTest < ActionView::TestCase

  test "should generate a list of rows with the reminders of a week organized to show in the calendar" do
    @reminder1 = reminders(:one)
    @reminder2 = reminders(:two)
    @reminder3 = reminders(:three)
    @reminder4 = reminders(:four)
    @reminder5 = reminders(:five)
    first_day = Date.parse('2022-06-19')
    week = Week.new(first_day)

    @reminders = [@reminder1,
                  @reminder2,
                  @reminder3,
                  @reminder4,
                  @reminder5
    ]

    @week_reminders = WeekReminders.new(week, @reminders)

    rows = organize_week_reminders_in_rows(@week_reminders)

    rows_valid = [
      [{reminder: nil}, {reminder: @reminder1, colspan: 1}, {reminder: nil}, {reminder: nil}, {reminder: @reminder3, colspan: 2}, {reminder: nil},],
      [{reminder: nil}, {reminder: @reminder2, colspan: 4}, {reminder: @reminder4, colspan: 1}, {reminder: nil}],
      [{reminder: nil}, {reminder: nil}, {reminder: nil}, {reminder: nil}, {reminder: nil}, {reminder: @reminder5, colspan: 2}]
    ]

    assert_equal rows, rows_valid
  end

  test "should generate an empty list when there is no reminder in the week" do
    first_day = Date.parse('2022-06-19')
    week = Week.new(first_day)

    @week_reminders = WeekReminders.new(week, [])

    rows = organize_week_reminders_in_rows(@week_reminders)

    assert_empty rows
  end

end