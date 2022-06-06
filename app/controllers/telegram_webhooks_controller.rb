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

  def code!(*num)
    # some image

    # ph = File.open('/Users/ivan/websites/expenses_bot/barcode.svg')
    # barcode
    image_name = SecureRandom.hex
    barcode = Barby::Code128B.new(num[0])
    png = Barby::PngOutputter.new(barcode).to_png(xdim: 2, ydim: 1)

    # p barcode
    # photo = File.write('barcode2.png', png.to_s)
    # p photo
    # IO.binwrite("tmp/#{image_name}.png", png.to_s)
    IO.binwrite('tmp/barcode.png', png.to_s)
    photo = File.open('tmp/barcode.png')

    respond_with :photo, photo: photo
  end

  def code13!(*_num)
    require 'barby/barcode/ean_13'
    num = '123456789009'
    barcode = Barby::EAN13.new(num)
    p barcode
    png = Barby::PngOutputter.new(barcode).to_png(xdim: 2, ydim: 1)
    IO.binwrite('tmp/EANbarcode.png', png.to_s)
    photo = File.open('tmp/EANbarcode.png')

    respond_with :photo, photo: photo
  end

  private

  def session_key
    "#{bot.username}:#{chat['id']}:#{from['id']}" if chat && from
  end
end
