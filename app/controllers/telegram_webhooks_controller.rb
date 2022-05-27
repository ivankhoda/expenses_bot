class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include UserHelper
  include ExpenseHelper
  include CallbackQueryHelper

  # Every update has one of: message, inline_query, chosen_inline_result,
  # callback_query, etc.
  # Define method with the same name to handle this type of update.
  def message(message)
    username = user_name message
    info = parse_message(message['text'])

    if user_exist(username) && info.is_a?(Hash)
      create_expense(info, current_user(username).id)
    else
      respond_with :message, text: info
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
          { text: 'Find expenses', callback_data: 'find_expenses' },
          { text: 'App1', web_app: { url: ENV['webapp_url'] } }
        ]
      ]
    }
  end

  def keyboard!(_word = nil, *_other_words)
    reply_with :message, text: 'Welcome to Expenses bot, please select item...', reply_markup: {

      keyboard: [
        [
          { text: 'App2', web_app: { url: ENV['webapp_url'] } }
        ]
      ]
    }
  end

  def callback_query(data)
    username = user_name update
    callback_query_answer_handler(data, username)
  end
end
