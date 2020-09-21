class Api::V1::ExpensesController < ActionController::API
  def create
    #FIXME: ユーザー認証機能の実装していないため、仮でユーザーを指定している
    user = User.first
    expense = user.expenses.build(expense_params)
    if expense.save
      category = expense.category
      render json: {
        "succeeded": true,
        "message": "出費を保存しました。#{category.name}: #{expense.amount.to_s(:delimited)}円"
      }
    else
      render json: {
        "succeeded": false,
        "message": expense.errors.full_messages.join("¥n")
      }
    end
  end

  def expense_params
    params.permit(:amount, :category_id, :date, :memo)
  end
end
