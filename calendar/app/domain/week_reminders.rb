class WeekReminders

  attr_accessor :week, :reminders

  def initialize(week, reminders)
    @week = week
    @reminders = filter_reminders(reminders)
  end

  def add_reminder(reminder)
    raise Exception.new "This reminder cannot be added to this week" unless reminder_from_this_week?(reminder)

    @reminders << reminder
  end

  def reminder_week_days(reminder)
    @week.intersection(reminder.start_datetime, reminder.end_datetime)
  end

  private

  def reminder_from_this_week?(reminder)
    @week.intersects?(reminder.start_datetime, reminder.end_datetime)
  end

  def filter_reminders(reminders)
    reminders.select do |reminder|
      reminder_from_this_week?(reminder)
    end
  end

end
