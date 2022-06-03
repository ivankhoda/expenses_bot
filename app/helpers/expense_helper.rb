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

  def group_expenses(expenses, time)
    message = ''
    total_expenses = 0
    expenses.each do |categories|
      category_expenses = 0
      categories[1].each do |expense|
        category_expenses += expense[:amount]
        total_expenses += expense.amount
      end
      message += "#{categories[0]}: #{category_expenses}\n"
    end
    message + "From #{period_of(time)}, to #{Date.today}\n" + "Total expenses:#{total_expenses}"
  end
end
