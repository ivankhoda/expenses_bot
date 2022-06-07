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

    else
      reply_with :message, text: 'Not found command'
    end
  end
end
