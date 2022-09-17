class Calendar

  attr_accessor :current_page

  def initialize(current_page)
    @current_page = current_page
  end

  def next_page
    Page.from_date(@current_page.last_day + 1.day)
  end

  def next_page!
    @current_page = next_page
  end

  def previous_page
    Page.from_date(@current_page.first_day - 1.day)
  end

  def previous_page!
    @current_page = previous_page
  end

end
