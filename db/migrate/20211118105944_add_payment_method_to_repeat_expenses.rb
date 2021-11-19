class AddPaymentMethodToRepeatExpenses < ActiveRecord::Migration[6.1]
  def change
    add_column :repeat_expenses, :payment_method, :integer, limit: 2, null: false, default: 0
  end
end
