class AddPaymentMethodToExpenses < ActiveRecord::Migration[6.1]
  def change
    add_column :expenses, :payment_method, :integer, limit: 2, null: false, default: 0
  end
end
