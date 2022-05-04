class TelegramWebhooksController < Telegram::Bot::UpdatesController
  # Every update has one of: message, inline_query, chosen_inline_result,
  # callback_query, etc.
  # Define method with the same name to handle this type of update.
  def message(message)
    username = message['chat']['username']
    message = parse_message(message['text'])

    user_params = { username: }
    user_exists = User.find_by_username(username)

    unless user_exists
      user = User.new(user_params)
      if user.save
        'You succesfully registred'
      else
        user.errors.messages
      end
    end
    user_exists = User.find_by_username(username)
    expense = Expense.new(message)
    expense.user_id = user_exists.id
    result_message = if expense.save
                       'Expense was created succesfully'
                     else
                       'Expanse was not created'
                     end

    respond_with :message, text: result_message
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
      reply_with :message, text: 'Welcome'
    when 'statistics'
      username = update['callback_query']['message']['chat']['username']
      current_user = User.find_by_username(username)
      expenses = current_user.expenses.group_by(&:category).sort_by { 'category' } if current_user

      reply_with :message, text: expenses
    else
      reply_with :message, text: 'Not found command'
    end
  end

  private

  def parse_message(message)
    amount = message.tr('^0-9', '').strip
    category = message.tr('0-9', '').strip
    parsed_message = { category:, amount: }
  end
end
