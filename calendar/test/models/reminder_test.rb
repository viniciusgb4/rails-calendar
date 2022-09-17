require "test_helper"

class ReminderTest < ActiveSupport::TestCase

  def setup
    @user = users(:one)
    @reminder = reminders(:one)
  end

  test "should not save a reminder without title" do
    @reminder.title = nil
    assert_not @reminder.save
  end

  test "title's size should be between 3 and 30" do
    @reminder.title = 'a' * 2
    assert_not @reminder.save
    @reminder.title = 'a' * 31
    assert_not @reminder.save
    @reminder.title = 'a' * 3
    assert @reminder.save
    @reminder.title = 'a' * 30
    assert @reminder.save
  end

  test "should not save without a description" do
    @reminder.description = nil
    assert_not @reminder.save
  end

  test "description's size should be between 3 and 200" do
    @reminder.description = 'a' * 2
    assert_not @reminder.save
    @reminder.description = 'a' * 201
    assert_not @reminder.save
    @reminder.description = 'a' * 3
    assert @reminder.save
    @reminder.description = 'a' * 200
    assert @reminder.save
  end

  test "end_datetime should be greater or equal to start_datetime" do
    datetime = DateTime.now

    @reminder.start_datetime = datetime
    @reminder.end_datetime = datetime
    assert @reminder.save

    @reminder.end_datetime = datetime + 1.second
    assert @reminder.save

    @reminder.end_datetime = datetime - 1.second
    assert_not @reminder.save
  end

  test "to_s is right" do
    @reminder.start_datetime = DateTime.new(2022,2,3,4,5,6)
    @reminder.end_datetime = DateTime.new(2022,2,4,4,50,6)
    start_datetime = "2022-02-03 04:05"
    end_datetime = "2022-02-04 04:50"

    text = "One Test (#{start_datetime} - #{end_datetime})"
    assert_equal text, @reminder.to_s
  end

end
