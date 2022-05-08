module ExpenseHelper
  def parse_message(message)
    amount = message.tr('^0-9', '').strip
    category = message.tr('0-9', '').strip
    category.chars[0].upcase!
    if !amount.blank? && !category.blank?
      { category:, amount: }
    else
      'Some params was blank'
    end
  end

  def create_expense(data, user_id)
    expense = Expense.new(data)
    expense.user_id = user_id
    result_message = if expense.save
                       'Expense was created succesfully'
                     else
                       'Expanse was not created'
                     end
    respond_with :message, text: result_message
  end

  def validate
    puts params
  end
end
