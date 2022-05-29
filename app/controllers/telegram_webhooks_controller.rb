class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include UserHelper
  include ExpenseHelper
  include CallbackQueryHelper

  # Every update has one of: message, inline_query, chosen_inline_result,
  # callback_query, etc.
  # Define method with the same name to handle this type of update.
  def message(message)
    username = update[:message][:from][:username]
    info = parse_message(message[:text])

    if !User.find_by_username(username).nil? && info.is_a?(Hash)
      Expense.create(info, current_user(username).id)
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

  def keyboard!(_word = 'nil', *_other_words)
    reply_with :message, text: 'Welcome to Expenses bot, please select item...', reply_markup: {

      keyboard: [
        [
          { text: 'App2', web_app: { url: ENV['webapp_url'] } }
        ]
      ]
    }
  end

  def callback_query(data)
    username = update[:callback_query][:from][:username]
    callback_query_answer_handler(data, username)
  end

  private

  def telegram_webhook_controller_params
    puts update[:message][:from][:username], 'from username mes>>>'
    puts update[:message][:chat][:username], 'username mes>>>'
    puts update[:message][:text], 'text mes>>>'
    puts update['message'].class
    puts update[:message], 'message username'
  end
end
