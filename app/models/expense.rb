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
      "Expense № #{expense.id} for #{expense.category} category was created succesfully"
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

  def find_all(username)
    require 'axlsx'
    current_user = User.find_by_username(username)
    expenses = current_user.expenses.find_all if current_user
    p = Axlsx::Package.new
    p.workbook do |wb|
      wb.add_worksheet(name: 'Items') do |sheet|
        sheet.add_row %w[Number Date Category Amount]
        expenses.each do |expense|
          sheet.add_row [expense.id, expense.created_at, expense.category, expense.amount]
        end
      end
    end
    p.serialize 'tmp/index.xlsx'
    File.open('/Users/ivan/websites/expenses_bot/tmp/index.xlsx')
  end

  def find_all_created_at(username, date)
    current_user = User.find_by_username(username)
    if current_user
      expenses = current_user.expenses.where('created_at BETWEEN ? AND ?', date.beginning_of_day, date.end_of_day).to_a
    end
    expenses
  end

  def find_by_id(username, id)
    current_user = User.find_by_username(username)
    expenses = current_user.expenses.where('id = ?', id).to_a if current_user
    expenses
  end

  def find_and_delete(username, id)
    current_user = User.find_by_username(username)
    if !find_by_id(username, id).empty?
      current_user.expenses.find(id).destroy
      "Expense with #{id} was successfully deleted"
    else
      "Seems you dont have #{id} expense"
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
      message += " #{categories[0]}: #{category_expenses}\n"
    end
    message + "From #{period_of(time)}, to #{Date.today}\n" + "Total expenses:#{total_expenses}"
  end
end
