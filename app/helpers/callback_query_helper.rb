module CallbackQueryHelper
  def callback_query_answer_handler(data, username)
    case data
    when 'log_expenses'
      if user_exist username
        reply_with :message, text: 'Enter category of your expense and amount'
      else
        respond_with :message, text: 'Sorry, seems that you have to register first'
      end
    when 'registration'
      if user_exist username
        user_already_registered
      else
        create_user username
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
      find_expenses_for(username, 'week')
    when 'month_stats'
      find_expenses_for(username, 'month')
    when 'year_stats'
      find_expenses_for(username, 'year')
    else
      reply_with :message, text: 'Not found command'
    end
  end
end
