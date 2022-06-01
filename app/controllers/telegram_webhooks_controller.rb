class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include UserHelper
  include ExpenseHelper
  include CallbackQueryHelper
  include TelegramWebhooksCommandsHelper

  # Every update has one of: message, inline_query, chosen_inline_result,
  # callback_query, etc.
  # Define method with the same name to handle this type of update.
  def message(message)
    p message, 'messaga'
    p update, 'upd'
    # username = update[:message][:from][:username]
    # info = parse_message(message[:text])
    # if !User.find_by_username(username).nil? && info.is_a?(Hash)
    #   expense = Expense.create({ category: info[:category], amount: info[:amount],
    #                              user_id: User.find_by_username(username).id })
    #   if expense.id
    #     respond_with :message,
    #                  text: "Expense #{expense.id} for #{expense.category} category was created succesfully"
    #   end
    # else
    respond_with :message, text: message
    # end
  end

  def web_app_message(web_app_data)
    p web_app_data, 'web_app_data'
    # username = update[:message][:from][:username]
    # info = parse_message(message[:text])
    # if !User.find_by_username(username).nil? && info.is_a?(Hash)
    #   expense = Expense.create({ category: info[:category], amount: info[:amount],
    #                              user_id: User.find_by_username(username).id })
    #   if expense.id
    #     respond_with :message,
    #                  text: "Expense #{expense.id} for #{expense.category} category was created succesfully"
    #   end
    # else
    respond_with :message, text: message
    # end
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
