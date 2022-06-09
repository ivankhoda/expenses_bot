module CallbackQueryHelper
  include UserHelper
  def callback_query_answer_handler(data, username)
    @expense = Expense.new
    case data
    when 'log_expenses'
      if !User.find_by_username(username).nil?
        reply_with :message, text: 'Enter category of your expense and amount'
      else
        respond_with :message, text: 'Sorry, seems that you have to register first'
      end

    when 'registration'
      if !User.find_by_username(username).nil?
        user_already_registered
      else
        User.create({ username: })
      end

    when 'statistics'
      reply_with :message, text: 'Please select period', reply_markup: {
        inline_keyboard: [
          [
            { text: 'Week', callback_data: 'week_stats' },
            { text: 'Month', callback_data: 'month_stats' },
            { text: 'Year', callback_data: 'year_stats' }
          ]
        ]
      }
    when 'week_stats'
      reply_with :message, text: @expense.find_expenses_for(username, 'week')
    when 'month_stats'
      reply_with :message, text: @expense.find_expenses_for(username, 'month')
    when 'year_stats'
      reply_with :message, text: @expense.find_expenses_for(username, 'year')

    when 'download_all_expenses'
      data = @expense.find_all(username)
      reply_with :document, document: data
    when 'find_by_date'
      save_context :select_expenses_by_date
      respond_with :message, text: 'Please input the date in format dd/mm/yyyy.'
    when 'find_by_id'
      save_context :select_expense_by_id
      respond_with :message, text: 'Please enter id of expense'
    when 'delete_expense'
      username = callback_query_username(update)
      expense_id = callback_query_message(update)
      data = @expense.find_and_delete(username, expense_id)
      respond_with :message, text: data

    when 'update_expense'
      save_context :update_expense

      respond_with :message, text: 'Please input new data for expense (category and/or amount)'
    else

      reply_with :message, text: 'Not found command'
    end
  end

  private

  def callback_query_message(update)
    HashWithIndifferentAccess.new(update)[:callback_query][:message][:reply_to_message][:text]
  end

  def callback_query_username(update)
    HashWithIndifferentAccess.new(update)[:callback_query][:from][:username]
  end
end
