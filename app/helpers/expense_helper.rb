module ExpenseHelper
  def parse_message(message)
    amount = message.tr('^0-9', '').strip
    category = message.tr('0-9', '').strip
    if !amount.blank? && !category.blank?
      category.chars[0].upcase!
      { category:, amount: }
    else
      'Please enter category and amount'
    end
  end

  def find_expenses_for(username, time)
    current_user = User.find_by_username(username)
    if current_user
      expenses = current_user.expenses.where('created_at >= ?', (period_of time)).group_by(&:category).sort_by do
        'category'
      end
    end
    message = group_expenses(expenses, time)
    reply_with :message, text: message
  end

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
