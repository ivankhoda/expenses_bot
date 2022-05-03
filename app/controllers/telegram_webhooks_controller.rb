class TelegramWebhooksController < Telegram::Bot::UpdatesController
  # Every update has one of: message, inline_query, chosen_inline_result,
  # callback_query, etc.
  # Define method with the same name to handle this type of update.
  def message(message)
    # store_message(message['text'])
  end

  def menu
    respond_with :message, text: t('.prompt'), reply_markup: {
      inline_keyboard: [
        [
          { text: t('.alert'), callback_data: 'alert' },
          { text: t('.no_alert'), callback_data: 'no_alert' }
        ],
        [{ text: t('.repo'), url: 'https://github.com/telegram-bot-rb/telegram-bot' }]
      ]
    }
  end

  # For the following types of updates commonly used params are passed as arguments,
  # full payload object is available with `payload` instance method.
  #
  #   message(payload)
  #   inline_query(query, offset)
  #   chosen_inline_result(result_id, query)
  #   callback_query(data)

  # Define public methods ending with `!` to handle commands.
  # Command arguments will be parsed and passed to the method.
  # Be sure to use splat args and default values to not get errors when
  # someone passed more or less arguments in the message.
  def start!(_word = nil, *_other_words)
    # do_smth_with(word)

    # full message object is also available via `payload` instance method:
    # process_raw_message(payload['text'])

    # There are `chat` & `from` shortcut methods.
    # For callback queries `chat` is taken from `message` when it's available.
    response = from ? "Hello #{from['username']}!" : 'Hi there!'

    # There is `respond_with` helper to set `chat_id` from received message:
    respond_with :message, text: response

    # `reply_with` also sets `reply_to_message_id`:
    reply_with :photo, photo: File.open('party.jpg')
  end

  def help!
    respond_with :message, text: 'menu', reply_markup: {
      inline_keyboard: [
        [
          { text: 'log expenses', callback_data: 'alert' },
          { text: 'stats', callback_data: 'no_alert' }
        ],
        [{ text: 'try', url: 'https://github.com/telegram-bot-rb/telegram-bot' }]
      ]
    }
  end

  private

  def with_locale(&block)
    I18n.with_locale(locale_for_update, &block)
  end

  def locale_for_update
    if from
      # locale for user
    elsif chat
      # locale for chat
    end
  end
end
