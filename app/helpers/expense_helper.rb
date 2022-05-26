module ExpenseHelper
  def parse_message(message)
    amount = message.tr('^0-9', '').strip
    category = message.tr('0-9', '').strip
    if !amount.blank? && !category.blank?
      category.chars[0].upcase!
      { category:, amount: }
    else
      # begin
      #   raise StandardError, 'Please enter category and amount'
      #   resque
      'Please enter category and amount'
      # end
    end
  end

  def create_expense(data, user_id)
    expense = Expense.new(data)
    expense.user_id = user_id
    result_message = if expense.save
                       "Expense #{expense.id} for #{expense.category} category was created succesfully"
                     else
                       'Expanse was not created'
                     end
    respond_with :message, text: result_message
  end

  def find_all_expenses_for_user(username)
    current_user = User.find_by_username(username)
    expenses = current_user.expenses.group_by(&:category).sort_by { 'category' } if current_user
    reply_with :message, text: expenses
  end

  def find_expenses_for(username, time)
    current_user = User.find_by_username(username)
    if current_user
      expenses = current_user.expenses.where('created_at >= ?', (period_of time)).group_by(&:category).sort_by do
        'category'
      end
    end
    message = group_expenses expenses
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

  def group_expenses(expenses)
    message = ''
    total_expenses = 0
    expenses.each do |categories|
      expenses = 0
      categories[1].each do |expense|
        expenses += expense[:amount]
        total_expenses += expenses
      end
      message = "#{message}#{categories[0]}: #{expenses}\n"
    end
    message + "Total expenses for period:#{total_expenses}"
  end
end
