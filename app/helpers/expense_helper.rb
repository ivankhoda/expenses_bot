module ExpenseHelper
  def parse_message(message)
    amount = message.tr('^0-9', '').strip
    category = message.tr('0-9', '').strip
    if !amount.blank? && !category.blank?
      { category:, amount: }
    else
      'Some params was blank'
    end
  end

  def validate
    puts params
  end
end
