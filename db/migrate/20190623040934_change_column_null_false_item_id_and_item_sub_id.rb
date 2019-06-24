class ChangeColumnNullFalseItemIdAndItemSubId < ActiveRecord::Migration[5.2]
  def change
    change_column_null :repeat_expenses, :item_id, false
    change_column_null :repeat_expenses, :item_sub_id, false
  end
end
