class AddUpdatedPeriodToRepeatExpenses < ActiveRecord::Migration[5.2]
  def change
    add_column :repeat_expenses, :updated_period, :integer, limit: 2, null: false, default: 0
  end
end
