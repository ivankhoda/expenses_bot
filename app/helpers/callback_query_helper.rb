module CallbackQueryHelper
  def callback_query_answer_handler(data, username)
    case data
    when 'log_expenses'
      reply_with :message, text: 'Enter category of your expense and amount'
    when 'registration'
      if user_exist username
        user_already_registered
      else
        create_user username
      end
    when 'statistics'
      find_all_expenses_for_user username
    else
      reply_with :message, text: 'Not found command'
    end
  end
end
