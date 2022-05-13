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
      respond_with :message, text: 'Please enter category and amount'
      # end
    end
  end

  def create_expense(data, user_id)
    expense = Expense.new(data)
    expense.user_id = user_id
    result_message = if expense.save
                       'Expense was created succesfully'
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

  def find_current_week_expenses_for_user(username)
    current_user = User.find_by_username(username)
    expenses = current_user.expenses.group_by(&:category).sort_by { 'category' } if current_user
    reply_with :message, text: expenses
  end

  def validate
    puts params
  end
end
