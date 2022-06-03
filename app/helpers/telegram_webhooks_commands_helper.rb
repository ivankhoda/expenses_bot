module TelegramWebhooksCommandsHelper
  include CallbackQueryHelper

  # Every update has one of: message, inline_query, chosen_inline_result,
  # callback_query, etc.
  # Define method with the same name to handle this type of update.
  def start!(_word = nil, *_other_words)
    reply_with :message, text: 'Welcome to Expenses bot, please select item...', reply_markup: {
      inline_keyboard: [
        [
          { text: 'Registration', callback_data: 'registration' },
          { text: 'Log expenses', callback_data: 'log_expenses' },
          { text: 'Statistics', callback_data: 'statistics' }
        ],
        [
          { text: 'App2', one_time_keyboard: true, web_app: { url: ENV['webapp_url'] } }
        ]
      ]
    }
  end

  def stats!(_word = nil, *_other_words)
    reply_with :message, text: 'Please select period', reply_markup: {
      inline_keyboard: [
        [
          { text: 'Week', callback_data: 'week_stats' },
          { text: 'Month', callback_data: 'month_stats' },
          { text: 'Year', callback_data: 'year_stats' }
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
    upd = HashWithIndifferentAccess.new(update)
    username = upd[:callback_query][:from][:username]
    callback_query_answer_handler(data, username)
  end
end
