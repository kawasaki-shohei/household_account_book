class AddIsEssentialToExpenses < ActiveRecord::Migration[6.1]
  def change
    add_column :expenses, :is_essential, :boolean, null: false, default: false, comment: '必須出費フラグ'
    add_column :repeat_expenses, :is_essential, :boolean, null: false, default: false, comment: '必須出費フラグ'
  end
end
