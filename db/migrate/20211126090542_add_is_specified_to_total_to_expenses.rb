class AddIsSpecifiedToTotalToExpenses < ActiveRecord::Migration[6.1]
  def up
    add_column :expenses, :is_specified_to_total, :boolean, null: false, default: false, comment: '特定出費フラグ'
    add_column :repeat_expenses, :is_specified_to_total, :boolean, null: false, default: false, comment: '特定出費フラグ'
    remove_column :expenses, :is_essential
    remove_column :repeat_expenses, :is_essential
  end

  def down
    add_column :expenses, :is_essential, :boolean, null: false, default: false, comment: '必須出費フラグ'
    add_column :repeat_expenses, :is_essential, :boolean, null: false, default: false, comment: '必須出費フラグ'
    remove_column :expenses, :is_specified_to_total
    remove_column :repeat_expenses, :is_specified_to_total
  end
end
