module ExpenseHelper
  def parse_message(message)
    amount = message.tr('^0-9', '').strip
    category = message.tr('0-9', '').strip
    category.chars[0].upcase!
    if !amount.blank? && !category.blank?
      { category:, amount: }
    else
      'Some params was blank'
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

  def validate
    puts params
  end
end
