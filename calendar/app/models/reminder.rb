class Reminder < ApplicationRecord
  belongs_to :user

  validates :title, presence: true, length: {minimum: 3, maximum: 30}
  validates :description, presence: true, length: {minimum: 3, maximum: 200}
  validate :reminder_dates_are_possible

  def reminder_dates_are_possible
    return if [end_datetime.blank?, start_datetime.blank?].any?
    if end_datetime < start_datetime
      errors.add(:end_datetime, 'must be greater than Start datetime')
    end
  end

  def self.find_by_date_interval(start_date, end_date)
    self.where('(DATE(start_datetime) >= :start AND DATE(end_datetime) >= :end)
              OR (DATE(start_datetime) <= :start AND DATE(end_datetime) >= :end)
              OR (DATE(start_datetime) <= :start AND DATE(end_datetime) <= :end)
              OR (DATE(start_datetime) >= :start AND DATE(end_datetime) <= :end)', start: start_date, end: end_date).order('start_datetime, id')
  end

  def self.find_by_date(date)
    self.where('DATE(start_datetime) >= ? AND DATE(end_datetime) <= ?', date, date)
  end

  def to_s
    date_format = "%Y-%m-%d %H:%M"
    "#{title} (#{start_datetime.strftime(date_format)} - #{end_datetime.strftime(date_format)})"
  end

end
