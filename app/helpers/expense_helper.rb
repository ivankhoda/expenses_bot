module ExpenseHelper
  def period_of(time)
    case time
    when 'week'
      Date.today.at_beginning_of_week
    when 'month'
      Date.today.at_beginning_of_month
    when 'year'
      Date.today.at_beginning_of_year
    end
  end
end
