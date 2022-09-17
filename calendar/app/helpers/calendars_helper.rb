module CalendarsHelper

  WEEK_DAYS = 7

  # Get all reminders of a week and organize them in rows to show in the calendar.
  # Each row has 7 columns, which represents the 7 days of a week. The reminders are
  # sorted by date and time and in a same day, each reminder is placed in a different
  # row. If there is no reminder to show in a row column (day), the method adds a hash
  # with nil reminder ({reminder: nil}). If a reminder lasts more than a day, the number
  # of days are placed in a colspan attribute and it represents different columns in this row.
  # @example Suppose the week (2022-06-19 - 2022-06-25) has the following reminders
  # r1 = {title: 'R1', start_datetime: '2022-06-20T08:00', start_datetime: '2022-06-20T09:00'}
  # r2 = {title: 'R2', start_datetime: '2022-06-21T08:00', start_datetime: '2022-06-21T09:00'}
  # r3 = {title: 'R3', start_datetime: '2022-06-21T08:00', start_datetime: '2022-06-25T09:00'}
  # r4 = {title: 'R4', start_datetime: '2022-06-25T08:00', start_datetime: '2022-06-25T09:00'}
  # The method returns the list:
  # [ [{reminder: nil}, {reminder: r1, colspan: 1}, {reminder: r2, colspan: 1}, {reminder: nil}, {reminder: nil}, {reminder: nil}, {reminder: r4, colspan: 1}] #row 1,
  #   [{reminder: nil}, {reminder: nil}, {reminder: r3, colspan: 5}] #row 2
  # ]
  # @return list of hashes organized to show in the calendar.
  #
  #
  def organize_week_reminders_in_rows(week_reminders)
    week = week_reminders.week
    reminders = week_reminders.reminders
    reminders.sort! { |a, b| a.start_datetime <=> b.start_datetime }

    rows = []
    row = []
    added_reminders = []
    reminders.each do |r|
      unless added_reminders.include?(r)
        days = week_reminders.reminder_week_days(r)
        blank_days = find_blank_days(week_reminders, r, week.first_day)
        row += blank_days
        num_days = blank_days.size
        num_days += days.size
        row.append({ reminder: r, colspan: days.size })
        added_reminders << r
        if num_days < 7
          (reminders - added_reminders).select { |sr| sr.start_datetime > days.last }.each do |r2|
            if r2.start_datetime.to_date > days.last.to_date
              blank_days = find_blank_days(week_reminders, r2, days.last + 1.day)
              days = week_reminders.reminder_week_days(r2)
              row += blank_days
              num_days += blank_days.size
              num_days += days.size
              if num_days <= 7
                row.append({ reminder: r2, colspan: days.size })
                added_reminders << r2
              else
                row -= blank_days
              end
            end
          end
        end
        if num_days < 7
          row += generate_blank_days(6 - num_days)
        end
        rows.append(row)
        row = []
      end
    end
    rows
  end

  private

  def find_blank_days(week_reminders, reminder, last_occupied_day)
    days = week_reminders.reminder_week_days(reminder)
    num_days = (days.first - last_occupied_day).to_i
    (1..num_days).map { |d| { reminder: nil } }
  end

  def generate_blank_days(num_days)
    (0..num_days).map { |d| { reminder: nil } }
  end

end
