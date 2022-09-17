class ApplicationController < ActionController::Base
  before_action :set_cache_headers
  before_action :authenticate_user!

  private

  def set_cache_headers
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Mon, 01 Jan 1990 00:00:00 GMT"
  end

  def cookies_set?
    cookies[:year] and cookies[:month]
  end

  def set_cookies
    cookies[:year] = @calendar.current_page.year
    cookies[:month] = @calendar.current_page.month
  end

  def calendar_from_cookies
    current_page = cookies_set? ? Page.new(cookies[:year].to_i, cookies[:month].to_i) : Page.from_date(Date.today)
    @calendar = Calendar.new(current_page)
  end

  def retrieve_reminders
    @reminders = Reminder.find_by_date_interval(@calendar.current_page.first_day, @calendar.current_page.last_day)
    weeks = @calendar.current_page.weeks
    @reminders_by_week = reminders_by_week(weeks)
  end

  def reminders_by_week(weeks)
    weeks.sort! { |a, b| a.first_day <=> b.first_day }
    reminders = Reminder.find_by_date_interval(weeks.first.first_day, weeks.last.last_day)
    weeks.map { |week|
      {week => WeekReminders.new(week, reminders)}
    }.reduce({}, :merge)
  end

end
