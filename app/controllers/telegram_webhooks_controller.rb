require 'barby'
require 'barby/barcode/code_128'
require 'barby/outputter/ascii_outputter'

require 'barby/outputter/png_outputter'

class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include ExpenseHelper
  include CallbackQueryHelper
  include TelegramWebhooksCommandsHelper
  # include Telegram::Bot::UpdatesController::TypedUpdate
  include Telegram::Bot::UpdatesController::MessageContext
  use_session!
  # Every update has one of: message, inline_query, chosen_inline_result,
  # callback_query, etc.
  # Define method with the same name to handle this type of update.
  def message(message)
    upd = HashWithIndifferentAccess.new(message)
    expense = Expense.new
    reply = expense.record(upd)

    respond_with :message, text: reply
  end

  def clean!
    session.delete(session.keys.last)
  end

  def put!(*args)
    session[:useful_info] = args.join(' ')
    respond_with :message, text: session[:useful_info]
  end

  private

  def session_key
    "#{bot.username}:#{chat['id']}:#{from['id']}" if chat && from
  end
end
