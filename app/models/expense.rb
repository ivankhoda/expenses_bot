class Expense < ApplicationRecord
  belongs_to :user

  def validate(message)
    to_valid = message
    p to_valid, 'to valid from class'
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
