class RemindersController < ApplicationController
  before_action :set_reminder, only: %i[ edit update destroy ]
  before_action :calendar_from_cookies, only: [:create, :update, :destroy]

  def new
    @reminder = Reminder.new
    @reminder.color = "blue1"
    @reminder.start_datetime = (params[:date].to_datetime + 8.hours)
    @reminder.end_datetime = (params[:date].to_datetime + 9.hours)
  end

  def create
    retrieve_reminders
    begin
      rem_params = reminder_params
      rem_params[:user] = current_user

      @reminder = Reminder.new(rem_params)
      if @reminder.save
        render_reminder
      else
        render_error
      end
    rescue ArgumentError, TypeError => e
      head :bad_request
    end
  end

  def update
    @reminder = Reminder.find(params[:id])
    weeks_before_update = weeks_by_reminder(@reminder)

    begin
      if @reminder.update(reminder_params)
        render_reminder(weeks_before_update)
      else
        render_error
      end
    rescue ArgumentError => e
      head :bad_request
    end
  end

  def destroy
    weeks = weeks_by_reminder(@reminder)
    if @reminder.destroy
      reminders_by_week = reminders_by_week(weeks)

      weeks.map { |week|
        ActionCable.server.broadcast "week_channel_#{week.to_s}", {
          week_reminders: render_to_string(partial: 'calendars/week_reminders',
                                  locals: { reminders_by_week: reminders_by_week, week: week })
        }
      }
      head :ok
    end
  end

  private

  def reminder_params
    begin
      params.require(:reminder).permit(:title, :description, :start_datetime, :end_datetime, :color)
    rescue ActionController::ParameterMissing => e
      render :file => 'public/400.html', :status => :bad_request, :layout => false
    end
  end

  def set_reminder
    begin
      @reminder = Reminder.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      render :file => 'public/404.html', :status => :not_found, :layout => false
    end
  end

  def render_reminder(weeks_before_update = nil)
    weeks = weeks_by_reminder(@reminder)
    weeks |= weeks_before_update if weeks_before_update
    reminders_by_week = reminders_by_week(weeks)


    weeks.map { |week|
      ActionCable.server.broadcast "week_channel_#{week.to_s}", {
        week_reminders: render_to_string(partial: 'calendars/week_reminders',
                              locals: { reminders_by_week: reminders_by_week, week: week })
      }
    }
    head :ok
  end

  def weeks_by_reminder(reminder)
    start_date = (reminder.start_datetime - (reminder.start_datetime.wday).days).to_date
    (start_date..reminder.end_datetime.to_date).step(7).map {|d| Week.new(d)}
  end

  def render_error
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream:
                 turbo_stream.update("reminder-modal-message",
                                     partial: 'reminders/errors',
                                     locals: { reminder: @reminder }),
               status: :unprocessable_entity
      end
    end
  end

end