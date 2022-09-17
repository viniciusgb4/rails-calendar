class Page

  PAGE_SIZE = 42
  DAYS_IN_WEEK = 7

  attr_reader :year, :month, :first_day, :last_day, :days, :weeks

  def self.from_date(date)
    new(date.year, date.month)
  end

  def initialize(year, month)
    @year = year
    @month = month
    start_date = Date.civil(@year, @month, 1)
    @first_day = start_date - start_date.wday
    @last_day = @first_day + (PAGE_SIZE - 1).days
    @days = (@first_day..@last_day).to_a
    @weeks = (@first_day..@last_day).step(DAYS_IN_WEEK).map { |first_day| Week.new(first_day) }
  end

end
