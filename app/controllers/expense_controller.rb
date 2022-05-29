class ExpenseController < ApplicationController
  def new
    @expense = Expense.new
  end

  def index
    puts request.query_parameters

    expenses = current_user.expenses.order(created_at: :desc)

    render json: { expences: }
  end

  def show
    expense = current_user.expenses.find_by(id: params[:id])
    render json: { expense: }
  end

  def create
    @expense = Expense.new(expense_params)
    if @expense.save
      respond_with :message, text: "Expense #{expense.id} for #{expense.category} category was created succesfully"
    else
      respond_with :message, text: 'Expense was not created'
    end
  end

  def show
    task = current_user.tasks.find_by(id: params[:id])
    render json: { task: }
  end

  private

  def expense_params
    puts params, 'parameteres'
    params.require(:expense).permit(:category, :amount, :user_id)
  end
end
