class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include UserHelper
  include ExpenseHelper
  include CallbackQueryHelper

  # Every update has one of: message, inline_query, chosen_inline_result,
  # callback_query, etc.
  # Define method with the same name to handle this type of update.
  def message(message)
    username = user_name message
    expense_data = parse_message(message['text'])
    puts expense_data.is_a? Hash
    if user_exist(username) && expense_data.is_a?(Hash)
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
        ],
        [
          { text: 'Find expenses', callback_data: 'find_expenses' }
        ]
      ]
    }
  end

  def callback_query(data)
    username = user_name update
    callback_query_answer_handler(data, username)
  end
end
