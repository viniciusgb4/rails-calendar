class CalendarsController < ApplicationController
  before_action :calendar_from_cookies, only: [:index, :previous_page, :next_page]
  after_action :set_cookies, only: [:previous_page, :next_page, :today]
  skip_before_action :authenticate_user!, only: [:index]

  def index
    retrieve_reminders
  end

  def previous_page
    @calendar.previous_page!
    render_calendar
  end

  def next_page
    @calendar.next_page!
    render_calendar
  end

  def today
    page = Page.from_date(Date.today)
    @calendar = Calendar.new(page)
    render_calendar
  end

  private

  def calendar_params
    params.require(:calendar).permit(:new_page)
  end

  def render_calendar
    retrieve_reminders
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update('calendar-body',
                              partial: 'calendars/calendar_body',
                              locals: {calendar: @calendar, reminders_by_week: @reminders_by_week}),
          turbo_stream.update('current-month',
                              partial: 'calendars/tools',
                              locals: { calendar: @calendar })
        ]
      end
    end
  end

end
