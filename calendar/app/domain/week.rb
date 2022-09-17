class Week
  attr_reader :first_day, :days, :last_day

  def initialize(first_day)
    @first_day = first_day
    @days = (@first_day..@first_day + 6.days).to_a
    @last_day = @first_day + 6.days
  end

  def includes?(day)
    @days.includes?(day)
  end

  def intersects?(first_day, last_day)
    not ((first_day.to_date..last_day.to_date).to_a & @days).empty?
  end

  def intersection(first_day, last_day)
    (first_day.to_date..last_day.to_date).to_a & @days
  end

  def eql?(week)
    self.first_day == week.first_day
  end

  def hash
    [@first_day].hash
  end

  def to_s
    "#{@first_day}"
  end

end
