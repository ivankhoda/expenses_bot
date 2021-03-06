class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include ExpenseHelper
  include CallbackQueryHelper
  include TelegramWebhooksCommandsHelper
  include Telegram::Bot::UpdatesController::MessageContext
  use_session!
  # Every update has one of: message, inline_query, chosen_inline_result,
  # callback_query, etc.
  # Define method with the same name to handle this type of update.
  def message(message)
    upd = HashWithIndifferentAccess.new(message)
    if !User.find_by_username(username).nil?
      expense = Expense.new
      reply = expense.record(upd)
      respond_with :message, text: reply
    else
      respond_with :message, text: 'We dont know you.'
      respond_with :message, text: 'Try to reg first', reply_markup: {
        inline_keyboard: [
          [
            { text: 'Registration', callback_data: 'registration' }
          ]
        ]
      }
    end
  end

  def select_expenses_by_date(date)
    dd_mm_20yy_regex = %r{^(3[01]|[12][0-9]|0?[1-9])/(1[0-2]|0?[1-9])/(20)[0-9]{2}}
    if date.match(dd_mm_20yy_regex)
      @expense = Expense.new
      data = @expense.find_all_created_at(username, Date.parse(date))
      respond_with :message, text: data
    else
      respond_with :message, text: 'Sorry, seems your input date is not valid, please check the format.'
    end
  end

  def select_expense_by_id(id)
    @expense = Expense.new
    data = @expense.find_by_id(username, id)
    if data.length == 0
      respond_with :message, text: "Seems like you dont have expense with id #{id}"
    else
      respond_with :message, text: data
      reply_with :message, text: 'What you want to do?', reply_markup: {
        inline_keyboard: [
          [
            { text: 'Delete', callback_data: 'delete_expense' },
            { text: 'Nothing', callback_data: 'do_nothing' }
          ]
        ]
      }
    end
  end

  def delete_confirmation
    respond_with :message, text: 'Are you sure?'
    reply_with :message, text: 'Are you sure?', reply_markup: {
      inline_keyboard: [
        [
          { text: 'Yes, delete', callback_data: 'delete_expense_confirmed' },
          { text: 'No, later', callback_data: 'do_nothing' }
        ]
      ]
    }
  end

  private

  def username
    upd = HashWithIndifferentAccess.new(update)
    upd[:message][:from][:username]
  end

  def session_key
    "#{bot.username}:#{chat['id']}:#{from['id']}" if chat && from
  end
end
