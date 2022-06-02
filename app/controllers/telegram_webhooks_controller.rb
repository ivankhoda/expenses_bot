class TelegramWebhooksController < Telegram::Bot::UpdatesController
  # include Telegram::Bot::UpdatesController::TypedUpdate
  include UserHelper
  include ExpenseHelper
  include CallbackQueryHelper
  include TelegramWebhooksCommandsHelper
  include Telegram::Bot::UpdatesController::TypedUpdate
  include Telegram::Bot::UpdatesController::MessageContext
  use_session!
  # Every update has one of: message, inline_query, chosen_inline_result,
  # callback_query, etc.
  # Define method with the same name to handle this type of update.
  def message(message)
    p message, 'MESSAGE'
    p session, 'session'
    # username = update[:message][:from][:username]
    # expense = Expense.new
    # expense.validate(message)
    # info = parse_message(message[:text])
    # if !User.find_by_username(username).nil? && info.is_a?(Hash)
    #   expense = Expense.create({ category: info[:category], amount: info[:amount],
    #                              user_id: User.find_by_username(username).id })
    #   if expense.id
    #     respond_with :message,
    #                  text: "Expense #{expense.id} for #{expense.category} category was created succesfully"
    #   end
    # else
    # respond_with :message, text: message

    respond_with :message, text: message
    # end
  end

  def chosen_inline_result(result_id, _query)
    session[:last_chosen_inline_result] = result_id
    p result_id, 'result id'
  end

  def help!(*)
    respond_with :message, text: '.content'
  end

  def memo!(*args)
    if args.any?

      session[:memo] = args.join(' ')
      respond_with :message, text: session[:memo]
    else
      respond_with :message, text: 'no memo'
      save_context :memo!
    end
  end

  def remind_me!(*)
    to_remind = session.delete(:memo)
    reply = to_remind || 'nothing'
    respond_with :message, text: reply
  end

  def keyboards!(value = nil, *)
    if value
      respond_with :message, text: value
    else
      save_context :keyboards!
      respond_with :message, text: 'some text for choosing keyboards buttons', reply_markup: {
        keyboard: [
          [{ text: 'Week' }],
          [{ text: 'Month' }],
          [{ text: 'Year' }]
        ],
        resize_keyboard: true,
        one_time_keyboard: true,
        selective: true
      }
    end
  end

  def inline_keyboard!(*)
    respond_with :message, text: t('.prompt'), reply_markup: {
      inline_keyboard: [
        [
          { text: 'no alert', callback_data: 'alert' },
          { text: 'alert', callback_data: 'no_alert' }
        ],
        [{ text: 'repo', url: 'https://github.com/telegram-bot-rb/telegram-bot' }]
      ]
    }
  end

  def callback_query(data)
    if data == 'alert'
      answer_callback_query 'boo', show_alert: true
    else
      answer_callback_query 'pick a boo'
    end
  end

  def inline_query(query, _offset)
    query = query.first(10) # it's just an example, don't use large queries.
    t_description = t('.description')
    t_content = t('.content')
    results = Array.new(5) do |i|
      {
        type: :article,
        title: "#{query}-#{i}",
        id: "#{query}-#{i}",
        description: "#{t_description} #{i}",
        input_message_content: {
          message_text: "#{t_content} #{i}"
        }
      }
    end
    answer_inline_query results
  end

  # As there is no chat id in such requests, we can not respond instantly.
  # So we just save the result_id, and it's available then with `/last_chosen_inline_result`.
  def chosen_inline_result(result_id, _query)
    session[:last_chosen_inline_result] = result_id
  end

  def last_chosen_inline_result!(*)
    result_id = session[:last_chosen_inline_result]
    if result_id
      respond_with :message, text: result_id
    else
      respond_with :message, text: 'll'
    end
  end

  def action_missing(_action, *_args)
    if action_type == :command
      respond_with :message,
                   text: t('telegram_webhooks.action_missing.command', command: action_options[:command])
    end
  end

  def write!(text = nil, *)
    session[:text] = text
  end

  def read!(*)
    respond_with :message, text: session[:text] if session[:text]
  end

  # In this case session will persist for user only in specific chat.
  # Same user in other chat will have different session.

  private

  def telegram_webhook_controller_params
    # puts update[:message][:from][:username], 'from username mes>>>'
    # puts update[:message][:chat][:username], 'username mes>>>'
    # puts update[:message][:text], 'text mes>>>'
    # puts update['message'].class
    # puts update[:message], 'message username'
  end

  def session_key
    "#{bot.username}:#{chat['id']}:#{from['id']}" if chat && from
  end
end
