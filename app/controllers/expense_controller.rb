class ExpenseController < ApplicationController
  def new
    @expense = Expense.new
  end

  def index
    puts request.query_parameters

    render json: { expences: }
  end

  def show
    expense = current_user.expenses.find_by(id: params[:id])
    render json: { expense: }
  end

  def create(expense_params)
    @expense = Expense.new(expense_params)
    if @expense.save
      "Expense #{expense.id} for #{expense.category} category was created succesfully"
    else
      'Expense was not created'
    end
  end

  private

  def expense_params
    puts params, 'parameteres'
    params.require(:message).permit(:category, :amount, :user_id)
  end
end
