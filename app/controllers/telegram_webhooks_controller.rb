class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include UserHelper
  include ExpenseHelper
  # Every update has one of: message, inline_query, chosen_inline_result,
  # callback_query, etc.
  # Define method with the same name to handle this type of update.
  def message(message)
    username = user_name message
    if user_exist username
      create_expense(parse_message(message['text']), current_user(username).id)

    else
      respond_with :message, text: 'Sorry, seems that you have to register first'
    end
  end

  def start!(_word = nil, *_other_words)
    reply_with :message, text: 'Welcome to Expenses bot, please select item...', reply_markup: {
      inline_keyboard: [
        [
          { text: 'Registration', callback_data: 'registration' },
          { text: 'Log expenses', callback_data: 'log_expenses' },
          { text: 'Statistics', callback_data: 'statistics' }
        ]
      ]
    }
  end

  def callback_query(data)
    case data
    when 'log_expenses'
      reply_with :message, text: 'Enter category of your expense and amount'
    when 'registration'
      username = user_name update
      if user_exist username
        reply_with :message, text: 'You already registered in bot'
      else
        create_user username
      end

    when 'statistics'
      username = user_name update
      current_user = User.find_by_username(username)
      expenses = current_user.expenses.group_by(&:category).sort_by { 'category' } if current_user
      reply_with :message, text: expenses
    else
      reply_with :message, text: 'Not found command'
    end
  end
end
