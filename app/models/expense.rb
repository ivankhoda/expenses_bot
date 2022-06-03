class Expense < ApplicationRecord
  belongs_to :user
  include ExpenseHelper

  def record(message)
    data = message[:text]
    user_id = User.find_by_username(message[:from][:username]).id
    category = data.tr('0-9', '').strip
    amount = data.tr('^0-9', '').strip
    if !amount.blank? && !category.blank?
      category.chars[0].upcase!
      expense = Expense.create({ category:, amount:, user_id: })
      "Expense #{expense.id} for #{expense.category} category was created succesfully"
    else
      "Please enter category and amount, you entered only #{amount.blank? ? 'category' : 'amount'}."
    end
  end

  def find_expenses_for(username, time)
    current_user = User.find_by_username(username)
    if current_user
      expenses = current_user.expenses.where('created_at >= ?', (period_of time)).group_by(&:category).sort_by do
        'category'
      end
    end
    group_expenses(expenses, time)
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
